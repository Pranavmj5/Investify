# ═══════════════════════════════════════════════════════════════
#  Investify — Direct file deploy (no WAR extraction)
#  Copies compiled classes and web files straight into Tomcat ROOT
# ═══════════════════════════════════════════════════════════════

FROM tomcat:10.1-jdk17

# Remove default Tomcat sample apps
RUN rm -rf /usr/local/tomcat/webapps/*

WORKDIR /usr/local/tomcat/webapps/ROOT

# Copy WEB-INF (compiled classes + libs + web.xml)
COPY WEB-INF/ ./WEB-INF/

# Copy root-level web files
COPY index.jsp   ./
COPY login.jsp   ./
COPY register.jsp ./

# Copy portal directories
COPY admin/      ./admin/
COPY founder/    ./founder/
COPY investor/   ./investor/
COPY government/ ./government/
COPY docs/       ./docs/

EXPOSE 8080

CMD ["catalina.sh", "run"]
