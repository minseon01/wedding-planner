#!/bin/bash
# data.json 변경 감지 시 자동으로 GitHub에 푸시
# 실행: ./auto-push.sh
# 종료: Ctrl+C

DIR="$(cd "$(dirname "$0")" && pwd)"
FILE="$DIR/data.json"

echo "👀 data.json 감시 중... (변경되면 자동 푸시)"
echo "   종료하려면 Ctrl+C"

fswatch -o "$FILE" | while read; do
  sleep 1  # 파일 쓰기 완료 대기
  cd "$DIR"
  if git diff --quiet data.json 2>/dev/null; then
    echo "$(date '+%H:%M:%S') - 변경 없음, 스킵"
  else
    git add data.json
    git commit -m "Auto-update data.json $(date '+%Y-%m-%d %H:%M:%S')"
    git push origin main && echo "$(date '+%H:%M:%S') ✅ 푸시 완료!" || echo "$(date '+%H:%M:%S') ❌ 푸시 실패"
  fi
done
