docker build -t adapss/printjob_docker:latest  .
docker run -v "//c/Users/SSpada/output:/app/output" -p 3000:3000 adapss/printjob_docker:latest