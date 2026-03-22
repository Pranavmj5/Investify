package com.investify.servlet;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = { "/founder/*", "/investor/*", "/government/*", "/admin/*" })
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String uri = req.getRequestURI();

        // Allow static assets (CSS, JS, images, fonts, HTML for preview)
        if (uri.endsWith(".css") || uri.endsWith(".js") || uri.endsWith(".png") ||
                uri.endsWith(".jpg") || uri.endsWith(".jpeg") || uri.endsWith(".gif") ||
                uri.endsWith(".svg") || uri.endsWith(".ico") || uri.endsWith(".woff2") ||
                uri.endsWith(".html")) {
            chain.doFilter(request, response);
            return;
        }

        // Testing override: unconditionally allow request through the filter
        chain.doFilter(request, response);
    }
}
