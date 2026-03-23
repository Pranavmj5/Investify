# ═══════════════════════════════════════════════════════════════
#  Investify — Direct file deploy (no WAR extraction)
#  Copies compiled classes and web files straight into Tomcat ROOT
# ═══════════════════════════════════════════════════════════════

FROM tomcat:10.1-jdk17

# Remove default Tomcat sample apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Disable the shutdown port (port 8005) — avoids health-check noise on Render
RUN sed -i 's/port="8005" shutdown="SHUTDOWN"/port="-1" shutdown="SHUTDOWN"/' \
    /usr/local/tomcat/conf/server.xml

WORKDIR /usr/local/tomcat/webapps/ROOT

# Copy WEB-INF (compiled classes + libs + web.xml)
COPY WEB-INF/ ./WEB-INF/

# Copy root-level web files
COPY index.jsp    ./
COPY login.jsp    ./
COPY register.jsp ./

# Copy portal directories
COPY admin/      ./admin/
COPY founder/    ./founder/
COPY investor/   ./investor/
COPY government/ ./government/
COPY docs/       ./docs/

# Debug: list files so we can see what Tomcat has
RUN echo "=== ROOT webapp contents ===" && ls -la /usr/local/tomcat/webapps/ROOT/ && \
    echo "=== WEB-INF/classes ===" && ls /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/com/investify/servlet/ || true

EXPOSE 8080

CMD ["catalina.sh", "run"]
