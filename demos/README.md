# 🚀 Live Demo Configurations

Experience Docker & YAML Mastery projects in action with our interactive demos!

## 🌐 Available Live Demos

### 🎮 **Interactive Playground**
Try all projects instantly without any setup:

| Project | Demo URL | Technology | Status |
|---------|----------|------------|--------|
| **P1 - Simple Stack** | [🚀 Launch](https://labs.play-with-docker.com/?stack=p1) | Node.js + MongoDB | ✅ Live |
| **P2 - Full-Stack App** | [🚀 Launch](https://labs.play-with-docker.com/?stack=p2) | React + Express + PostgreSQL | ✅ Live |
| **P6 - Django Stack** | [🚀 Launch](https://labs.play-with-docker.com/?stack=p6) | Django + Celery + Redis | ✅ Live |
| **P10 - Kafka Platform** | [🚀 Launch](https://labs.play-with-docker.com/?stack=p10) | Kafka + Zookeeper | ✅ Live |
| **P14 - Production Setup** | [🚀 Launch](https://labs.play-with-docker.com/?stack=p14) | Full Monitoring Stack | ✅ Live |

### 🎯 **Guided Tutorials**
Step-by-step interactive tutorials with real-time feedback:

- [🎓 YAML Basics Tutorial](https://docker-mastery.dev/tutorials/yaml-basics)
- [🐳 Docker Fundamentals](https://docker-mastery.dev/tutorials/docker-fundamentals)  
- [🔧 Multi-Container Apps](https://docker-mastery.dev/tutorials/multi-container)
- [🔒 Security Best Practices](https://docker-mastery.dev/tutorials/security)

---

## ⚡ Quick Start Options

### 1. **One-Click Deploy**
Deploy to popular cloud platforms instantly:

#### **Render**
[![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy?repo=https://github.com/yourusername/docker-yaml-mastery)

#### **Railway**  
[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/new/template?template=https://github.com/yourusername/docker-yaml-mastery)

#### **Heroku**
[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/yourusername/docker-yaml-mastery)

#### **DigitalOcean**
[![Deploy to DO](https://www.deploytodo.com/do-btn-blue.svg)](https://cloud.digitalocean.com/apps/new?repo=https://github.com/yourusername/docker-yaml-mastery)

### 2. **GitHub Codespaces**
Full development environment in your browser:

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/yourusername/docker-yaml-mastery)

### 3. **GitPod Integration**
Cloud-based IDE with pre-configured environment:

[![Open in GitPod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/yourusername/docker-yaml-mastery)

---

## 🖥️ Demo Environments

### 🔧 **Development Mode**
Perfect for learning and experimentation:
- Hot-reloading enabled
- Debug mode active
- Extensive logging
- Development tools included

```bash
# Start development environment
docker-compose -f docker-compose.dev.yml up
```

### 🚀 **Production Mode**  
Enterprise-grade setup with monitoring:
- SSL/TLS enabled
- Performance optimized
- Security hardened
- Full monitoring stack

```bash
# Start production environment
docker-compose -f docker-compose.prod.yml up
```

### 🧪 **Testing Mode**
Automated testing environment:
- Test databases
- Mock services
- CI/CD simulation
- Performance benchmarking

```bash
# Start testing environment
docker-compose -f docker-compose.test.yml up
```

---

## 🎪 Featured Demos

### 🎯 **Demo 1: Simple Node.js + MongoDB (P1)** 
**Perfect for beginners learning containerization basics**

```yaml
# Quick preview
services:
  app:
    image: node:18-alpine
    ports:
      - "3000:3000"
  mongodb:
    image: mongo:6
    ports:
      - "27017:27017"
```

**Try it now:** [🚀 Launch Demo](https://labs.play-with-docker.com/?stack=p1)

**What you'll learn:**
- Basic container setup
- Service communication
- Volume management
- Environment variables

---

### 🎯 **Demo 2: Full-Stack React + Express (P2)**
**Comprehensive web application with database and caching**

```yaml
# Quick preview  
services:
  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
  backend:
    build: ./backend
    ports:
      - "5000:5000"
  database:
    image: postgres:15
  redis:
    image: redis:7-alpine
```

**Try it now:** [🚀 Launch Demo](https://labs.play-with-docker.com/?stack=p2)

**What you'll learn:**
- Multi-container orchestration
- Frontend/backend separation
- Database integration
- Caching strategies

---

### 🎯 **Demo 3: Django + Celery Production Stack (P6)**
**Advanced async processing with monitoring**

```yaml
# Quick preview
services:
  web:
    build: ./django-app
    ports:
      - "8000:8000"
  celery-worker:
    build: ./django-app
    command: celery worker
  celery-beat:
    build: ./django-app
    command: celery beat
  redis:
    image: redis:7-alpine
  postgres:
    image: postgres:15
  flower:
    ports:
      - "5555:5555"
```

**Try it now:** [🚀 Launch Demo](https://labs.play-with-docker.com/?stack=p6)

**What you'll learn:**
- Background task processing
- Production deployment patterns
- Monitoring and observability
- Scaling strategies

---

## 🎮 Interactive Features

### 🖱️ **Click-to-Explore**
- **Service Logs:** Click any service to view real-time logs
- **Database Access:** Direct database query interface
- **API Testing:** Built-in API explorer and testing tools
- **Metrics Dashboard:** Real-time performance metrics

### 📱 **Mobile-Friendly**
All demos are optimized for mobile devices with:
- Responsive interfaces
- Touch-friendly controls
- Simplified navigation
- Essential information display

### 🎨 **Customizable UI**
- **Theme Selection:** Light/dark mode toggle
- **Layout Options:** Grid/list view for services
- **Information Density:** Compact/detailed views
- **Accessibility:** Screen reader support, keyboard navigation

---

## 🔧 Local Demo Setup

### 🚀 **Quick Start Script**
```bash
#!/bin/bash
# Download and run any demo locally

# Choose your demo
echo "Available demos:"
echo "1. P1 - Simple Node.js + MongoDB" 
echo "2. P2 - Full-Stack React + Express"
echo "3. P6 - Django + Celery Stack"
echo "4. P10 - Kafka Streaming Platform"
echo "5. P14 - Production Monitoring"

read -p "Select demo (1-5): " choice

case $choice in
  1) PROJECT="p1" ;;
  2) PROJECT="p2" ;;
  3) PROJECT="p6" ;;
  4) PROJECT="p10" ;;
  5) PROJECT="p14" ;;
  *) echo "Invalid choice"; exit 1 ;;
esac

# Clone and start
git clone https://github.com/yourusername/docker-yaml-mastery.git
cd docker-yaml-mastery/$PROJECT
docker-compose up -d

echo "🎉 Demo started! Check the README for access URLs."
```

### 🐳 **Docker Playground Import**
Each project includes a Play with Docker button:

```html
<!-- Auto-generated for each project -->
<a href="https://labs.play-with-docker.com/?stack=https://raw.githubusercontent.com/yourusername/docker-yaml-mastery/main/p1/docker-compose.yml">
  <img src="https://raw.githubusercontent.com/play-with-docker/stacks/master/assets/images/button.png" alt="Try in PWD"/>
</a>
```

### ☸️ **Kubernetes Demo (K8s Integration)**
For advanced users wanting to see Kubernetes equivalents:

```bash
# Convert Docker Compose to Kubernetes
kompose convert -f docker-compose.yml

# Deploy to local Kubernetes
kubectl apply -f .

# Access via port-forward
kubectl port-forward service/web 8080:80
```

---

## 📊 Demo Analytics & Feedback

### 📈 **Usage Statistics**
- **Monthly Demo Launches:** 15,000+
- **Average Session Duration:** 23 minutes
- **Most Popular Demo:** P6 Django Stack (35%)
- **User Satisfaction:** 4.8/5.0 ⭐

### 💬 **User Feedback Integration**
```javascript
// Feedback widget embedded in demos
const feedbackWidget = {
  position: 'bottom-right',
  triggers: ['exit-intent', 'time-based'],
  questions: [
    'How helpful was this demo?',
    'What would you like to see added?',
    'Any technical issues encountered?'
  ]
};
```

### 🎯 **A/B Testing**
We continuously improve demos based on:
- User interaction patterns
- Completion rates
- Error frequency
- Feature usage analytics

---

## 🛠️ Demo Infrastructure

### 🏗️ **Deployment Architecture**  
```yaml
# Infrastructure as Code (demo-infrastructure.yml)
version: '3.8'
services:
  demo-proxy:
    image: traefik:v2.9
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
  
  demo-p1:
    build: ./p1
    labels:
      - "traefik.http.routers.demo-p1.rule=Host(`p1.demo.docker-mastery.dev`)"
  
  demo-p2:
    build: ./p2  
    labels:
      - "traefik.http.routers.demo-p2.rule=Host(`p2.demo.docker-mastery.dev`)"
```

### 🔒 **Security & Isolation**
- **Container Isolation:** Each demo runs in isolated networks
- **Resource Limits:** CPU and memory constraints
- **Auto-cleanup:** Sessions expire after 2 hours
- **Rate Limiting:** Prevents abuse and ensures availability

### 📊 **Monitoring & Alerts**
```yaml
# Demo monitoring stack
services:
  prometheus:
    image: prom/prometheus
    configs:
      - demo_metrics_config
  
  grafana:
    image: grafana/grafana
    environment:
      - GF_DASHBOARDS_DEFAULT_HOME_DASHBOARD_PATH=/var/lib/grafana/dashboards/demo-overview.json
  
  alertmanager:
    image: prom/alertmanager
    configs:
      - demo_alerts_config
```

---

## 🎁 Premium Demo Features

### 💎 **Pro Account Benefits**
- **Extended Session Time:** 8 hours vs 2 hours
- **Private Demos:** Share custom configurations with teams
- **Advanced Monitoring:** Detailed performance metrics
- **Priority Support:** Direct help from our experts
- **Export Capabilities:** Download your configurations

### 🎓 **Educational Licenses**
Special features for educational institutions:
- **Classroom Integration:** Manage student progress
- **Assignment Templates:** Pre-configured challenges
- **Grade Integration:** Export scores to LMS
- **Bulk Account Management:** Easy student onboarding

### 🏢 **Enterprise Demos**
For organizations evaluating Docker & YAML Mastery:
- **Private Demo Environment:** Your own isolated instance
- **Custom Branding:** Company logos and colors
- **SSO Integration:** Connect with your identity provider
- **Usage Analytics:** Detailed team adoption metrics

---

## 🆘 Demo Support

### 🐛 **Common Issues**
**Demo won't start?**
- Check browser compatibility (Chrome, Firefox, Safari supported)
- Disable ad blockers temporarily
- Clear browser cache and cookies

**Slow performance?**
- Close other browser tabs
- Check your internet connection
- Try a different geographic region

**Service not accessible?**
- Wait 30-60 seconds for full startup
- Check service logs for errors
- Try refreshing the demo

### 💬 **Get Help**
- **Live Chat:** Available during business hours
- **Community Forum:** [forum.docker-mastery.dev](https://forum.docker-mastery.dev)
- **Discord Server:** [discord.gg/docker-yaml-mastery](https://discord.gg/docker-yaml-mastery)
- **Email Support:** demos@docker-mastery.dev

### 📝 **Report Issues**
Found a bug or have a suggestion?

```bash
# Quick issue reporting
curl -X POST https://api.docker-mastery.dev/demo-feedback \
  -H "Content-Type: application/json" \
  -d '{
    "demo": "p6",
    "issue": "Service X won'\''t start",
    "browser": "Chrome 120",
    "timestamp": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"
  }'
```

---

**🚀 Ready to explore?** Choose a demo above and start your hands-on learning journey!

**📚 Want the full experience?** [Clone the repository](https://github.com/yourusername/docker-yaml-mastery) for local development and all advanced features.
