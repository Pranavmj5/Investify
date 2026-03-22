package com.investify.db;

import java.sql.Connection;
import java.sql.DriverManager;

/**
 * Canonical DB connection class for Investify.
 * Returns null (never throws) to avoid crashing Tomcat startup on Render
 * when environment variables are not yet available.
 *
 * Required environment variables on Render:
 *   DB_URL   e.g. jdbc:mysql://host:port/dbname?useSSL=false&allowPublicKeyRetrieval=true
 *   DB_USER  e.g. root
 *   DB_PASS  e.g. yourpassword
 */
public class DBConnection {

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("[DBConnection] MySQL JDBC Driver not found: " + e.getMessage());
        }
    }

    public static Connection getConnection() {
        try {
            String url      = System.getenv("DB_URL");
            String user     = System.getenv("DB_USER");
            String password = System.getenv("DB_PASS");

            if (url == null || user == null || password == null) {
                System.err.println("[DBConnection] WARNING: DB env vars missing (DB_URL / DB_USER / DB_PASS)");
                return null;
            }

            return DriverManager.getConnection(url, user, password);

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
