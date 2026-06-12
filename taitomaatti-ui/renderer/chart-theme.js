/**
 * Taitomaatti UI — kaaviovärit ja Chart.js-teema.
 * Sama paletti kuin tokens.css:n --chart-* -muuttujissa.
 *
 * Käyttö Chart.js:n kanssa:
 *   import { palette, applyChartTheme } from "./chart-theme.js";
 *   applyChartTheme(Chart);
 */

export const palette = {
  blue: "#5aa9ff",
  amber: "#f2b04e",
  orange: "#ff8c2e",
  green: "#49d68a",
  red: "#ff5d3a",
  cream: "#f7ecd4",
  series: ["#5aa9ff", "#f2b04e", "#ff8c2e", "#49d68a", "#ff5d3a", "#f7ecd4"],
  grid: "rgba(110, 82, 36, 0.25)",
  text: "#94815f",
  textBright: "#d9c9a6",
  tooltipBg: "rgba(11, 8, 5, 0.95)",
  tooltipBorder: "#6e5224",
};

/** Liukuväri pystypalkkeihin (canvas-konteksti vaaditaan). */
export function barGradient(ctx, color = palette.amber, height = 200) {
  const g = ctx.createLinearGradient(0, 0, 0, height);
  g.addColorStop(0, color);
  g.addColorStop(1, color + "33"); // häivytys alas, kuten kuvan palkeissa
  return g;
}

/** Asettaa Chart.js:n globaalit oletukset Taitomaatti-ilmeeseen. */
export function applyChartTheme(Chart) {
  const d = Chart.defaults;
  d.color = palette.text;
  d.borderColor = palette.grid;
  d.font.family =
    '"Bahnschrift", "Saira Semi Condensed", "Roboto Condensed", "Segoe UI", sans-serif';
  d.font.size = 11;

  d.plugins.legend.labels.boxWidth = 10;
  d.plugins.legend.labels.color = palette.textBright;
  d.plugins.tooltip.backgroundColor = palette.tooltipBg;
  d.plugins.tooltip.borderColor = palette.tooltipBorder;
  d.plugins.tooltip.borderWidth = 1;
  d.plugins.tooltip.titleColor = "#f7ecd4";
  d.plugins.tooltip.bodyColor = palette.textBright;

  d.elements.line.borderWidth = 2;
  d.elements.line.tension = 0.35;
  d.elements.point.radius = 0;
  d.elements.arc.borderColor = "#0b0805";
  d.elements.arc.borderWidth = 2;
  d.elements.bar.borderRadius = 2;
}
