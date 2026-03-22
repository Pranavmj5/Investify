# ═══════════════════════════════════════════════════════════════
#  Investify — Multi-stage Docker build
#  Stage 1: Compile Java source using Tomcat's servlet-api.jar
#  Stage 2: Deploy compiled app on Tomcat 10.1 (Jakarta EE)
# ═══════════════════════════════════════════════════════════════

# ── Stage 1: Build ──────────────────────────────────────────────
FROM tomcat:10.1-jdk17 AS builder

WORKDIR /build

# Copy Java source and dependencies
COPY src/           src/
COPY WEB-INF/lib/   WEB-INF/lib/
COPY WEB-INF/web.xml WEB-INF/web.xml

# Compile all Java sources against Tomcat's servlet-api.jar
RUN mkdir -p WEB-INF/classes && \
    find src -name "*.java" > sources.txt && \
    javac -encoding UTF-8 \
          -cp "/usr/local/tomcat/lib/servlet-api.jar:WEB-INF/lib/*" \
          -d WEB-INF/classes \
          @sources.txt

# Package into a WAR
RUN cp -r WEB-INF/ /tmp/war/ 2>/dev/null; \
    mkdir -p /tmp/war && \
    cp -r WEB-INF /tmp/war/ && \
    jar -cvf /tmp/investify.war -C /tmp/war .

# ── Stage 2: Deploy ─────────────────────────────────────────────
FROM tomcat:10.1-jdk17

# Remove default Tomcat sample apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Create the ROOT context webapp directory directly (faster than WAR extraction)
WORKDIR /usr/local/tomcat/webapps/ROOT

# Copy WEB-INF (compiled classes + lib + web.xml) from builder
COPY --from=builder /build/WEB-INF ./WEB-INF/

# Copy all web content from repo
COPY index.jsp      ./
COPY login.jsp      ./
COPY register.jsp   ./
COPY admin/         ./admin/
COPY founder/       ./founder/
COPY investor/      ./investor/
COPY government/    ./government/
COPY docs/          ./docs/

EXPOSE 8080

CMD ["catalina.sh", "run"]
