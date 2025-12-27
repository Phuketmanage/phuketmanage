import puppeteer from "puppeteer";

const readStdin = async () => {
  const chunks = [];
  for await (const chunk of process.stdin) chunks.push(chunk);
  return Buffer.concat(chunks).toString("utf8");
};

const main = async () => {
  const raw = await readStdin();
  const payload = JSON.parse(raw);

  const browser = await puppeteer.launch({
    headless: "new",
    args: [
      "--no-sandbox",
      "--disable-setuid-sandbox",
      "--font-render-hinting=none"
    ],
  });

  try {
    const page = await browser.newPage();

    // Important: allow external images/fonts if you use absolute URLs
    await page.setContent(payload.html, { waitUntil: "networkidle0" });

    const pdf = await page.pdf({
      format: payload.format || "A4",
      printBackground: true,
      landscape: !!payload.landscape,
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
