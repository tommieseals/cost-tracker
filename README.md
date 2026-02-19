# ???? Cost Tracker

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Bash](https://img.shields.io/badge/bash-5.0+-green.svg)](https://www.gnu.org/software/bash/)

**Track LLM API costs across multiple providers with charts and alerts.**

## The Problem

Using multiple LLM providers (OpenAI, Anthropic, local Ollama, etc.) makes it hard to:
- Know how much you're spending daily
- See which provider is costing most
- Get alerts before you blow your budget
- Track token usage trends

## The Solution

Cost Tracker aggregates usage from all your LLM providers and gives you:
- **Real-time cost tracking** across all providers
- **Daily/weekly/monthly reports** with charts
- **Budget alerts** when approaching limits
- **Export to CSV/JSON** for analysis

## Quick Start

### One-Command Install

```bash
curl -sSL https://raw.githubusercontent.com/tommieseals/cost-tracker/main/install.sh | bash
```

### Manual Install

```bash
git clone https://github.com/tommieseals/cost-tracker.git
cd cost-tracker
./install.sh
```

### Usage

```bash
# Track today's usage (run this periodically)
cost-tracker --track

# Show summary
cost-tracker --summary

# Export to CSV
cost-tracker --export csv > costs.csv

# Export to JSON
cost-tracker --export json > costs.json

# Check budget alerts
cost-tracker --alerts
```

## Supported Providers

| Provider | Token Tracking | Cost Calculation | Free Tier |
|----------|---------------|------------------|-----------|
| OpenAI   | Yes           | Automatic        | No        |
| Anthropic| Yes           | Automatic        | No        |
| Ollama   | Yes           | Free ($0)        | Yes       |
| NVIDIA NIM | Yes         | Free tier        | Yes (50/day) |
| OpenRouter | Yes         | Automatic        | Some free |
| Perplexity | Yes         | Automatic        | No        |

## Configuration

Set environment variables or create ~/.config/cost-tracker/config:

```bash
# Budget thresholds
ALERT_THRESHOLD_DAILY=5.00
ALERT_THRESHOLD_WEEKLY=25.00
ALERT_THRESHOLD_MONTHLY=100.00

# Data sources
TOKEN_LOG=~/logs/token-usage.log
METRICS_DIR=~/metrics
```

## Output Example

```
Cost and Token Tracker
======================
Date: 2025-02-19

FREE TIER:
  Ollama:  45 calls (0 tokens local)
  NVIDIA:  23/50 daily calls

PAID:
  OpenRouter: 12 calls ($0.024)
  Claude:     3 sessions (~$0.063)

TOTAL TODAY: $0.087

7-DAY TOTAL: $0.43
MONTHLY PROJECTION: $2.61
```

## Visualization

Generate ASCII charts:

```bash
cost-tracker --chart week
```

```
Daily Costs (Last 7 Days)
$0.15 |        *
$0.10 |  *  *  *  *
$0.05 |  *  *  *  *  *  *
$0.00 +------------------
       M  T  W  T  F  S  S
```

## Cron Setup

Add to crontab for automatic tracking:

```bash
# Track every hour
0 * * * * /usr/local/bin/cost-tracker --track

# Daily summary at 9 AM
0 9 * * * /usr/local/bin/cost-tracker --summary | mail -s "Daily LLM Costs" you@email.com
```

## License

MIT License - see LICENSE

