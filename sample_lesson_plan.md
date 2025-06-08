# Weather Data Visualization - Sample Lesson Plan

## Educational Data Visualization with R Shiny

**Duration:** 90 minutes (can be split into 2 x 45-minute sessions)  
**Level:** Undergraduate/Graduate introductory data science  
**Prerequisites:** Basic understanding of statistical concepts  
**Software:** R, RStudio, Weather Data Visualization Shiny App

---

## Learning Objectives

By the end of this lesson, students will be able to:

1. **Identify** appropriate visualization types for different data relationships
2. **Create** and interpret scatter plots, line plots, and bar charts
3. **Analyze** weather data patterns using interactive visualizations
4. **Evaluate** the effectiveness of different chart types for specific questions
5. **Apply** data visualization best practices in their own work

---

## Lesson Structure

### Session 1: Introduction to Data Visualization (45 minutes)

#### Opening (10 minutes)

- **Warm-up Question:** "What makes a good data visualization?"
- **Learning Objectives Review**
- **Dataset Introduction:** Explore the weather data context

#### Core Activity 1: Variable Types and Chart Selection (20 minutes)

**Instructor Demonstration (10 minutes):**

1. Launch the Weather Data Visualization app
2. Navigate through the interface (sidebar, tabs, help section)
3. Demonstrate variable selection and chart type options
4. Show the recommendation system in action

**Student Activity (10 minutes):**

- Students launch the app and familiarize themselves with the interface
- Complete the "Getting Started" exploration in pairs
- Identify different variable types in the dataset

#### Core Activity 2: Scatter Plot Analysis (15 minutes)

**Guided Practice:**

1. **Exercise 1A: Temperature Relationships**

   - Select `MaxTemp` (X-axis) and `MinTemp` (Y-axis)
   - Choose Scatter Plot visualization
   - Enable trend line option
   - **Discussion Questions:**
     - What type of relationship do you observe?
     - How would you describe the correlation strength?
     - Are there any outliers? What might explain them?

2. **Exercise 1B: Pressure and Humidity**
   - Select `Pressure9am` (X-axis) and `Humidity9am` (Y-axis)
   - Compare with and without grouping by `RainToday`
   - **Discussion Questions:**
     - Does grouping by rain status reveal different patterns?
     - What does this suggest about weather relationships?

---

### Session 2: Advanced Visualization and Analysis (45 minutes)

#### Core Activity 3: Time Series and Trends (15 minutes)

**Exercise 2: Seasonal Patterns**

1. Select observation index (X-axis) and `Temp9am` (Y-axis)
2. Choose Line Plot visualization
3. **Analysis Questions:**
   - Can you identify seasonal patterns in the data?
   - When do temperatures appear to be highest/lowest?
   - How does this compare to `Temp3pm` patterns?

**Extension:**

- Try different atmospheric variables (humidity, pressure, sunshine)
- Look for correlations between different time-based patterns

#### Core Activity 4: Categorical Analysis (15 minutes)

**Exercise 3: Wind and Rain Patterns**

1. **Part A:** Wind Direction Analysis
   - Select `WindDir9am` (X-axis) with Bar Chart
   - **Questions:** Which wind directions are most common?
2. **Part B:** Rain Impact Analysis

   - Select `RainToday` (X-axis) and `Humidity9am` (Y-axis) with Bar Chart
   - **Questions:** How does humidity differ between rainy and non-rainy days?

3. **Part C:** Advanced Grouping
   - Experiment with different categorical/continuous combinations
   - Use the grouping feature to add another dimension

#### Core Activity 5: Data Table Exploration (10 minutes)

**Exercise 4: Raw Data Investigation**

1. Switch to the Data Table tab
2. **Tasks:**
   - Sort data by different variables
   - Filter for specific conditions (e.g., high rainfall days)
   - Search for extreme values
   - **Questions:**
     - What's the highest recorded temperature? When did it occur?
     - Find the rainiest day - what were the other conditions?

#### Wrap-up and Reflection (5 minutes)

**Discussion Questions:**

- Which visualization type was most useful for answering different questions?
- What patterns surprised you in the weather data?
- How might you apply these techniques to other datasets?

---

## Assessment Activities

### Formative Assessment (During Class)

- **Think-Pair-Share:** Students discuss chart type recommendations
- **Gallery Walk:** Students share interesting findings with the class
- **Exit Ticket:** One thing learned, one question remaining

### Summative Assessment Options

#### Option 1: Mini-Report (30 points)

Students write a 500-word analysis including:

- 3 different visualizations with explanations (15 points)
- Interpretation of patterns found (10 points)
- Recommendations for further analysis (5 points)

#### Option 2: Peer Teaching (25 points)

Students create a 5-minute presentation demonstrating:

- One visualization technique to classmates (10 points)
- Clear explanation of when to use this chart type (10 points)
- Interactive Q&A with audience (5 points)

#### Option 3: Data Story (35 points)

Students develop a narrative including:

- Research question about weather patterns (5 points)
- 4-5 visualizations supporting their investigation (20 points)
- Evidence-based conclusions (10 points)

---

## Extension Activities

### For Advanced Students

1. **Statistical Analysis:** Calculate correlation coefficients for relationships observed
2. **Seasonal Decomposition:** Identify and quantify seasonal patterns
3. **Outlier Investigation:** Research specific dates with extreme values

### For Different Disciplines

- **Environmental Science:** Focus on climate patterns and weather relationships
- **Geography:** Explore regional weather characteristics
- **Statistics:** Emphasize correlation, distribution analysis, and hypothesis testing
- **Computer Science:** Discuss the technical implementation of interactive visualizations

---

## Technical Requirements

### Pre-Class Setup

1. **Instructor Checklist:**

   - [ ] R and RStudio installed on classroom computers
   - [ ] Weather app files downloaded and ready
   - [ ] Run `install_packages.R` to verify all dependencies
   - [ ] Test app launch with `launch_app.R`
   - [ ] Backup plan: screenshots of key visualizations

2. **Student Preparation:**
   - Email setup instructions 24 hours before class
   - Provide troubleshooting contact information
   - Have USB drives with app files as backup

### During Class

- **Tech Support Strategy:** Pair programming for technical issues
- **Backup Plans:** Pre-made visualizations if apps fail
- **Time Management:** Use timer for activities, buffer time for tech issues

---

## Differentiation Strategies

### For Struggling Students

- **Scaffolded Worksheets:** Step-by-step instructions for each exercise
- **Peer Support:** Partner less experienced students with tech-savvy classmates
- **Simplified Questions:** Focus on basic pattern identification rather than complex analysis

### For Advanced Students

- **Open-Ended Exploration:** "Find something interesting in the data"
- **Cross-Variable Analysis:** Explore relationships between 3+ variables
- **Technical Challenges:** Investigate the app's code structure

### For English Language Learners

- **Visual Emphasis:** Focus on chart interpretation over written analysis
- **Vocabulary Support:** Provide glossary of meteorological terms
- **Collaborative Work:** Encourage discussion to build academic language

---

## Follow-Up Activities

### Homework Options

1. **Data Collection:** Students gather weather data from their hometown for comparison
2. **Visualization Critique:** Analyze weather visualizations in news media
3. **Personal Dataset:** Apply learned techniques to a dataset of student's choice

### Next Steps

- **Advanced Visualizations:** Introduction to specialized plot types
- **Statistical Modeling:** Using visualization to inform statistical analysis
- **Data Collection:** Principles of good data gathering for visualization

---

## Resources and References

### For Instructors

- [Shiny App Documentation](README.md)
- [R for Data Science - Data Visualization](https://r4ds.had.co.nz/data-visualisation.html)
- [Fundamentals of Data Visualization](https://clauswilke.com/dataviz/)

### For Students

- App Help tab with built-in guidance
- [Weather variable glossary](https://en.wikipedia.org/wiki/Weather_station)
- [Chart type selection guide](https://www.data-to-viz.com/)

### Technical Support

- Package installation script: `install_packages.R`
- Quick launcher: `launch_app.R`
- Troubleshooting guide in README.md

---

## Lesson Plan Evaluation

### What Worked Well

_To be completed after lesson delivery_

### Areas for Improvement

_To be completed after lesson delivery_

### Student Feedback Summary

_To be completed after lesson delivery_

### Modifications for Next Time

_To be completed after lesson delivery_

---

**Prepared by:** [Instructor Name]  
**Date:** [Date]  
**Course:** [Course Name and Number]  
**Institution:** [Institution Name]
