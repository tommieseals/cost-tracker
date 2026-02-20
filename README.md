# 💰 Cost Tracker

[![CI](https://github.com/tommieseals/cost-tracker/actions/workflows/ci.yml/badge.svg)](https://github.com/tommieseals/cost-tracker/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Bash](https://img.shields.io/badge/bash-5.0+-green.svg)](https://www.gnu.org/software/bash/)
[![Python](https://img.shields.io/badge/python-3.8+-blue.svg)](https://www.python.org/)

**Track LLM API costs across multiple providers with charts and alerts.**

Stop getting surprised by API bills. Cost Tracker aggregates usage from all your LLM providers and shows you exactly where your money is going—before it's gone.

## 🎯 Features

- **Real-time tracking** across OpenAI, Anthropic, Ollama, NVIDIA, OpenRouter
- **Budget alerts** via Telegram, Slack, or email when approaching limits
- **Daily/weekly/monthly reports** with ASCII charts
- **Cost projections** based on usage patterns
- **Export to CSV/JSON** for accounting and compliance

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      COST TRACKER                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   ┌─────────────┐ ┌─────────────┐ ┌─────────────┐          │
│   │   OpenAI    │ │  Anthropic  │ │   Ollama    │          │
│   │   Parser    │ │   Parser    │ │   Parser    │          │
│   └──────┬──────┘ └──────┬──────┘ └──────┬──────┘          │
│          │               │               │                  │
│          └───────────────┼───────────────┘                  │
│                          │                                  │
│                 ┌────────▼────────┐                         │
│                 │   Aggregator    │                         │
│                 │  • Per provider │                         │
│                 │  • Per model    │                         │
│                 │  • Per day      │                         │
│                 └────────┬────────┘                         │
│                          │                                  │
│          ┌───────────────┼───────────────┐                  │
│          │               │               │                  │
│   ┌──────▼──────┐ ┌──────▼──────┐ ┌──────▼──────┐          │
│   │   Reports   │ │   Alerts    │ │   Export    │          │
│   │ • Daily     │ │ • Telegram  │ │ • CSV       │          │
│   │ • Weekly    │ │ • Slack     │ │ • JSON      │          │
│   │ • Charts    │ │ • Email     │ │ • Metrics   │          │
│   └─────────────┘ └─────────────┘ └─────────────┘          │
└─────────────────────────────────────────────────────────────┘
```

## 🚀 Quick Start

### Installation

```bash
# One-liner
curl -sSL https://raw.githubusercontent.com/tommieseals/cost-tracker/main/install.sh | bash

# Or clone manually
git clone https://github.com/tommieseals/cost-tracker.git
cd cost-tracker
./install.sh
```

### Usage

```bash
# Track today's usage
cost-tracker --track

# Show summary
cost-tracker --summary

# View weekly chart
cost-tracker --chart week

# Export to CSV
cost-tracker --export csv > costs.csv

# Check budget alerts
cost-tracker --alerts
```

## 📊 Example Output

```
╔════════════════════════════════════════════════════════════╗
║              LLM Cost Report - Feb 19, 2025                ║
╠════════════════════════════════════════════════════════════╣
║                                                            ║
║  FREE TIER                                                 ║
║  ├─ Ollama (local):     45 calls      $0.00               ║
║  └─ NVIDIA NIM:         23/50 calls   $0.00               ║
║                                                            ║
║  PAID                                                      ║
║  ├─ OpenRouter:         12 calls      $0.024              ║
║  ├─ Claude API:         3 sessions    $0.063              ║
║  └─ OpenAI:             8 calls       $0.041              ║
║                                                            ║
╠════════════════════════════════════════════════════════════╣
║  TODAY:           $0.128                                   ║
║  THIS WEEK:       $0.847                                   ║
║  THIS MONTH:      $3.21                                    ║
║  PROJECTION:      $4.82/month                              ║
╚════════════════════════════════════════════════════════════╝
```

### Weekly Chart

```
Daily Costs (Last 7 Days)
$0.20 │                    
$0.15 │        ██          
$0.10 │  ██    ██ ██       
$0.05 │  ██ ██ ██ ██ ██ ██ 
$0.00 └────────────────────
       Mon Tue Wed Thu Fri Sat Sun
       
Top Models: gpt-4o-mini (45%), claude-3-haiku (30%), phi3:mini (25%)
```

## 📦 Supported Providers

| Provider | Token Tracking | Cost Calculation | Free Tier |
|----------|---------------|------------------|-----------|
| OpenAI   | ✅ | Automatic | No |
| Anthropic| ✅ | Automatic | No |
| Ollama   | ✅ | Free ($0) | Yes |
| NVIDIA NIM | ✅ | Free tier | 50/day |
| OpenRouter | ✅ | Automatic | Some models |
| Perplexity | ✅ | Automatic | No |
| Groq | ✅ | Automatic | Yes (rate limited) |

## ⚙️ Configuration

Create `~/.config/cost-tracker/config.yaml`:

```yaml
# Budget thresholds
budgets:
  daily: 5.00
  weekly: 25.00
  monthly: 100.00

# Alert channels
alerts:
  telegram:
    enabled: true
    bot_token: ${TELEGRAM_BOT_TOKEN}
    chat_id: ${TELEGRAM_CHAT_ID}
  slack:
    enabled: false
    webhook: ${SLACK_WEBHOOK}

# Data sources
sources:
  openai:
    api_key: ${OPENAI_API_KEY}
  anthropic:
    api_key: ${ANTHROPIC_API_KEY}
  ollama:
    url: http://localhost:11434
```

## 📈 Cron Setup

Automate tracking with cron:

```bash
# Track every hour
0 * * * * /usr/local/bin/cost-tracker --track

# Daily summary at 9 AM
0 9 * * * /usr/local/bin/cost-tracker --summary | mail -s "Daily LLM Costs" you@email.com

# Weekly report on Mondays
0 9 * * 1 /usr/local/bin/cost-tracker --report weekly
```

## 🔌 API Usage

```python
from cost_tracker import Tracker, Provider

tracker = Tracker()

# Get today's costs
today = tracker.get_costs(period="today")
print(f"Today: ${today.total:.2f}")

# Get costs by provider
for provider in today.by_provider:
    print(f"  {provider.name}: ${provider.cost:.2f}")

# Check if over budget
if tracker.is_over_budget(period="daily"):
    tracker.send_alert("Daily budget exceeded!")

# Get monthly projection
projection = tracker.project_monthly()
print(f"Projected: ${projection:.2f}/month")
```

## 📜 License

MIT License - see [LICENSE](LICENSE)
