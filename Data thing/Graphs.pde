// Pie chart
void pieChart(float cx, float cy, float diameter, String[] labels, color[] colors, float[] values) {
  float total = 0;    //sum of all values
  for (float v : values) total += v;

  float startAngle = -HALF_PI;      //start from top
  noStroke();

  // sector
  for (int i = 0; i < values.length; i++) {
    float angle = TWO_PI * (values[i] / total);
    fill(colors[i]);
    arc(cx, cy, diameter, diameter, startAngle, startAngle + angle, PIE);   //pie sector,  draw arc from startAngle to startAngle + angle
    startAngle += angle;   //advance for next slice
  }

  // draw legend below  chart
  float legendY = cy + diameter / 2 + 40;
  float legendX = cx - (values.length * 160) / 2.0;

  for (int i = 0; i < values.length; i++) {
    fill(colors[i]);
    rect(legendX, legendY, 16, 16, 4);

    fill(darkMode ? color(255) : color(58, 140, 110));
    textSize(15);
    textAlign(LEFT, CENTER);
    text(labels[i] + ": " + (int)values[i], legendX + 22, legendY + 8);  //draw text: "label: value" next to the square

    legendX += 160;    //move right for next legend item
  }
}


// Bar chart
void barChart(float chartLeft, float chartTop, float chartRight, float chartBottom,
              String[] labels, int[] counts) {
                
  if (labels == null || labels.length == 0) return;   //if label is empty return

  int maxCount = 0;    //largeset value in counts
  for (int c : counts){
    if (c > maxCount) maxCount = c;
  }

  float barWidth = (chartRight - chartLeft) / (labels.length * 2);  // barWidth = chart width / (number of bars * 2)
  float spacing  = barWidth / 2;   // spacing  = barWidth / 2

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
  for (int i = 0; i <= 5; i++) {       // Draw 5 horizontal grid lines with Y-axis labels
    float y = chartBottom - (i * (chartBottom - chartTop) / 5.0);
    stroke(darkMode ? 60 : 210);
    line(chartLeft, y, chartRight, y);    //draw faint horizontal grid line at y
    fill(darkMode ? 180 : 80);
    textSize(11);
    textAlign(RIGHT, CENTER);
    text((int)(i * maxCount / 5.0), chartLeft - 6, y);   //draw Y-axis label = (i / 5) * maxCount
  }

  // draw each bar
  for (int i = 0; i < labels.length; i++) {
    float x = chartLeft + spacing + i * (barWidth + spacing * 2);  //position of each bar by stepping "i" slots to the right
    float barHeight = map(counts[i], 0, maxCount, 0, chartBottom - chartTop);  //map() rescales the count proportionally into pixel height
    float y = chartBottom - barHeight;   //y is calculated upward from the bottom

    //Draw the bar rectangle
    fill(palette[i % palette.length]);  //cycles through colors so it never goes out of bounds
    noStroke();
    rect(x, y, barWidth, barHeight, 4, 4, 0, 0);    //rounds only the top-left and top-right corners (bottom stays flat against the axis)

    // Draw the count number above the bar
    fill(darkMode ? 240 : 30);
    textSize(11);
    textAlign(CENTER, BOTTOM);
    text(counts[i], x + barWidth/2, y - 4);

    // Draw the label below the axis
    textAlign(CENTER, TOP);
    String label = labels[i].length() > 10 ? labels[i].substring(0, 10) + "..." : labels[i];
    text(label, x + barWidth/2, chartBottom + 6);
  }
}
