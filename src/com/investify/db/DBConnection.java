package com.investify.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Single, canonical DB connection class for Investify.
 * Reads all credentials from environment variables — no hardcoded values.
 *
 * Required environment variables:
 *   DB_URL   e.g. jdbc:mysql://host:port/dbname?useSSL=false&allowPublicKeyRetrieval=true
 *   DB_USER  e.g. root
 *   DB_PASS  e.g. yourpassword
 */
public class DBConnection {

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC Driver not found", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        String url      = System.getenv("DB_URL");
        String user     = System.getenv("DB_USER");
        String password = System.getenv("DB_PASS");

        if (url == null || user == null || password == null) {
            throw new RuntimeException(
                "Database environment variables not set properly. " +
                "Please set DB_URL, DB_USER, and DB_PASS."
            );
        }

        return DriverManager.getConnection(url, user, password);
    }
}
