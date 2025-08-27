#!/bin/bash
Xvfb :99 -screen 0 1920x1080x24 &
export DISPLAY=:99
exec streamlit run app/Home.py --server.port=8501 --server.address=0.0.0.0
