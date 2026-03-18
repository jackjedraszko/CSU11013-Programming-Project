// ===== Pie chart =====
void pieChart(float cx, float cy, float diameter, String[] labels, color[] colors, float[] values) {
  float total = 0;
  for (float v : values) total += v;

  float startAngle = -HALF_PI;
  noStroke();

  // sector
  for (int i = 0; i < values.length; i++) {
    float angle = TWO_PI * (values[i] / total);
    fill(colors[i]);
    arc(cx, cy, diameter, diameter, startAngle, startAngle + angle, PIE);
    startAngle += angle;
  }

  // legend
  float legendY = cy + diameter / 2 + 40;
  float legendX = cx - (values.length * 160) / 2.0;

  for (int i = 0; i < values.length; i++) {
    fill(colors[i]);
    rect(legendX, legendY, 16, 16, 4);

    fill(darkMode ? color(255) : color(58, 140, 110));
    textSize(15);
    textAlign(LEFT, CENTER);
    text(labels[i] + ": " + (int)values[i], legendX + 22, legendY + 8);

    legendX += 160;
  }
}


// ===== Bar chart =====
void barChart(float chartLeft, float chartTop, float chartRight, float chartBottom,
              String[] labels, int[] counts) {
                
  if (labels == null || labels.length == 0) return;

  int maxCount = 0;
  for (int c : counts){
    if (c > maxCount) maxCount = c;
  }

  float barWidth = (chartRight - chartLeft) / (labels.length * 2);
  float spacing  = barWidth / 2;

  color[] palette = {
    color(#4a6fa5), color(#3a8c6e), color(#e07b54),
    color(#5bc0eb), color(#9b59b6), color(#e74c3c),
    color(#f39c12), color(#1abc9c)
  };

  // axes
  stroke(darkMode ? 200 : 80);
  strokeWeight(2);
  line(chartLeft, chartTop, chartLeft, chartBottom);
  line(chartLeft, chartBottom, chartRight, chartBottom);

  // grid lines + Y labels
  strokeWeight(1);
  for (int i = 0; i <= 5; i++) {
    float y = chartBottom - (i * (chartBottom - chartTop) / 5.0);
    stroke(darkMode ? 60 : 210);
    line(chartLeft, y, chartRight, y);
    fill(darkMode ? 180 : 80);
    textSize(11);
    textAlign(RIGHT, CENTER);
    text((int)(i * maxCount / 5.0), chartLeft - 6, y);
  }

  // bars
  for (int i = 0; i < labels.length; i++) {
    float x = chartLeft + spacing + i * (barWidth + spacing * 2);
    float barHeight = map(counts[i], 0, maxCount, 0, chartBottom - chartTop);
    float y = chartBottom - barHeight;

    fill(palette[i % palette.length]);
    noStroke();
    rect(x, y, barWidth, barHeight, 4, 4, 0, 0);

    // count on top of bar
    fill(darkMode ? 240 : 30);
    textSize(11);
    textAlign(CENTER, BOTTOM);
    text(counts[i], x + barWidth/2, y - 4);

    // label below bar
    textAlign(CENTER, TOP);
    String label = labels[i].length() > 10 ? labels[i].substring(0, 10) + "..." : labels[i];
    text(label, x + barWidth/2, chartBottom + 6);
  }
}
