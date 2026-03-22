# ─────────────────────────────────────────────
#  Investify – Docker Deployment
#  Base: Tomcat 10.1 on JDK 17 (Jakarta EE 10)
# ─────────────────────────────────────────────
FROM tomcat:10.1-jdk17

# Remove Tomcat's default sample webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the WAR as ROOT.war so the app serves at /
COPY investify.war /usr/local/tomcat/webapps/ROOT.war

# Expose Tomcat's default HTTP port
EXPOSE 8080

# Start Tomcat in the foreground (required by Docker / Render)
CMD ["catalina.sh", "run"]
