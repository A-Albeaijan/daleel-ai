@echo off
rem نشر الدليل على GitHub Pages بأمر واحد
rem المتطلبات: GitHub CLI (مثبت مسبقًا على هذا الجهاز) + تسجيل دخول واحد
chcp 65001 >nul
cd /d "%~dp0"

where gh >nul 2>nul || (echo [!] GitHub CLI غير موجود — ثبّته: winget install GitHub.cli ثم أعد المحاولة & pause & exit /b 1)

gh auth status >nul 2>nul
if errorlevel 1 (
  echo [=] أول مرة: سجّل دخولك في GitHub — افتح الرابط اللي يطلع وأدخل الرمز
  call gh auth login --web --git-protocol https || (echo [x] فشل تسجيل الدخول & pause & exit /b 1)
)

set REPO=daleel-ai
echo [=] إنشاء المستودع %REPO% ورفع الملفات...
gh repo create %REPO% --public --source=. --push --description "دليل عربي تفاعلي شامل لتعلّم الذكاء الاصطناعي — من الرياضيات إلى الوكلاء" 2>nul || git push -u origin main 2>nul

echo [=] تفعيل GitHub Pages...
gh api -X POST repos/{owner}/%REPO%/pages -f "source[branch]=main" -f "source[path]=/" >nul 2>&1

for /f "tokens=*" %%u in ('gh api repos/{owner}/%REPO% --jq .html_url') do set REPOURL=%%u
echo.
echo ✅ تم! بعد دقيقة-دقيقتين سيكون الدليل متاحًا على:
echo    %REPOURL:github.com=github.io%
echo    (المستودع: %REPOURL%)
echo.
pause
