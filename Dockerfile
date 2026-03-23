# ═══════════════════════════════════════════════════════════════
#  Investify — Single-stage Docker deploy
#  Deploys the pre-built investify.war directly onto Tomcat 10.1
# ═══════════════════════════════════════════════════════════════

FROM tomcat:10.1-jdk17

# Remove default Tomcat sample apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Deploy WAR as ROOT context (accessible at /)
COPY investify.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
