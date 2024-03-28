const { isProduction } = require("./utils");
const { v4: uuidv4 } = require('uuid');

const generateNamespace = () => {
  return uuidv4();
};

const getRandomUserAgent = () => {
  const operatingSystems = [
    "Windows NT 10.0",
    "Windows NT 6.1",
    "Windows NT 6.3",
    "Macintosh; Intel Mac OS X 10_15_7",
    "Macintosh; Intel Mac OS X 10_14_6",
    "Linux x86_64",
  ];

  const browsers = [
    "Chrome",
    "Edge",
    "Brave",
    "Opera",
  ];

  const randomOS = operatingSystems[Math.floor(Math.random() * operatingSystems.length)];
  const randomBrowser = browsers[Math.floor(Math.random() * browsers.length)];

  const chromeVersions = [
    "94.0.4606.71",
    "93.0.4577.63",
    "93.0.4577.62",
    "93.0",
    "90.0.818.62",
    "89.0",
    "90.0.4430.85",
    "89.0.4389.114",
    "123.0.6312.86",
    "109.0.5414.165",
    "124.0.6367.18",
    "119.0.6045.214",
    "104.0.5112.64",
    "91.0.4472.147",
  ];
  const randomChromeVersion = chromeVersions[Math.floor(Math.random() * chromeVersions.length)];

  return `Mozilla/5.0 (${randomOS}) AppleWebKit/537.36 (KHTML, like Gecko) ${randomBrowser}/${randomChromeVersion} Safari/537.36`;
};

module.exports = {
  USER_IDS: process.env.USER_IDS.split(","),
  WEBSOCKET_URLS: isProduction()
    ? ["wss://proxy.wynd.network:4650", "wss://proxy.wynd.network:4444"]
    : ["ws://proxy.dev.getgrass.io:4343"],
  NAMESPACE: generateNamespace(),
  PING_INTERVAL: 20 * 1000, // 20s in ms
  COOKIE_JAR_LIFESPAN: 60 * 60 * 24 * 1000, // 24hrs in ms
  USER_AGENT: getRandomUserAgent(),
};
