# Use a lightweight Nginx image as the base
FROM nginx:alpine

# Copy the index.html file from the host to the default Nginx HTML directory
COPY index.html /usr/share/nginx/html/index.html
COPY style.css /usr/share/nginx/html/
COPY Images /usr/share/nginx/html/
 
# Use a lightweight Node.js image as the base
# Expose port 80 (default for HTTP)
EXPOSE 80

# Start Nginx when the container starts
CMD ["nginx", "-g", "daemon off;"]
