import puppeteer from "puppeteer-core";
import fs from "node:fs";

const readStdin = async () => {
  const chunks = [];
  for await (const chunk of process.stdin) chunks.push(chunk);
  return Buffer.concat(chunks).toString("utf8");
};

const resolveChromePath = () => {
  if (process.env.PUPPETEER_EXECUTABLE_PATH) return process.env.PUPPETEER_EXECUTABLE_PATH;
  if (process.env.GOOGLE_CHROME_BIN) return process.env.GOOGLE_CHROME_BIN;
  if (process.env.CHROME_BIN) return process.env.CHROME_BIN;

  const candidates = [
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
    "/Applications/Chromium.app/Contents/MacOS/Chromium",
    "/usr/bin/google-chrome",
    "/usr/bin/google-chrome-stable",
    "/usr/bin/chromium",
    "/usr/bin/chromium-browser",
    "/app/.apt/usr/bin/google-chrome",
    "/app/.apt/usr/bin/google-chrome-stable",
    "/app/.apt/usr/bin/chromium-browser",
  ];

  return candidates.find((p) => fs.existsSync(p));
};

const main = async () => {
  const raw = await readStdin();
  const payload = JSON.parse(raw);

  const executablePath = resolveChromePath();
  if (!executablePath) {
    throw new Error("Chrome executable not found. Set PUPPETEER_EXECUTABLE_PATH or GOOGLE_CHROME_BIN.");
  }

  const browser = await puppeteer.launch({
    headless: "new",
    executablePath,
    args: ["--no-sandbox", "--disable-setuid-sandbox", "--disable-dev-shm-usage"],
  });

  try {
    const page = await browser.newPage();
    await page.setContent(payload.html, { waitUntil: "domcontentloaded" });

    const pdf = await page.pdf({
      format: payload.format || "A4",
      printBackground: true,
      landscape: !!payload.landscape,
      margin: payload.margin || { top: "12mm", right: "12mm", bottom: "15mm", left: "12mm" },
      displayHeaderFooter: !!(payload.header_html || payload.footer_html),
      headerTemplate: payload.header_html || "<div></div>",
      footerTemplate: payload.footer_html || "<div></div>",
    });

    process.stdout.write(Buffer.from(pdf).toString("base64"));
  } finally {
    await browser.close();
  }
};

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
