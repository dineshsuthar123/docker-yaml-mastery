---
title: "YAML Fundamentals Quiz"
description: "Test your understanding of YAML syntax and concepts"
difficulty: "beginner"
estimated_time: 10
total_questions: 15
pass_score: 70
topics: ["yaml-syntax", "data-types", "configuration"]
---

# 🧠 YAML Fundamentals Quiz

## Question 1
**What does YAML stand for?**

- A) Yet Another Markup Language
- B) YAML Ain't Markup Language ✅
- C) Young Agile Markup Language
- D) Youthful Application Markup Language

**Explanation:** YAML is a recursive acronym that stands for "YAML Ain't Markup Language"

---

## Question 2
**Which character is used to denote comments in YAML?**

- A) //
- B) <!-- -->
- C) # ✅
- D) /*

**Explanation:** The hash symbol (#) is used for comments in YAML

---

## Question 3
**Complete the YAML syntax for a list:**

```yaml
fruits:
___
  - apple
  - banana
  - orange
```

**Answer:** No character needed (proper indentation is sufficient)

---

## Question 4
**What is the correct way to represent a multi-line string in YAML?**

- A) description: "This is a long string that spans multiple lines"
- B) description: | ✅
     This is a long string
     that spans multiple lines
- C) description: \n This is a long string \n that spans multiple lines
- D) description: [This is a long string, that spans multiple lines]

**Explanation:** The pipe symbol (|) preserves line breaks in multi-line strings

---

## Question 5
**Which of the following is a valid YAML boolean value?**

- A) true ✅
- B) True ✅  
- C) TRUE ✅
- D) All of the above ✅

**Explanation:** YAML is case-insensitive for boolean values

---

## Question 6
**What is wrong with this YAML?**

```yaml
user:
  name: John
age: 30
```

- A) Missing quotes around John
- B) Inconsistent indentation ✅
- C) Missing colon after user
- D) Nothing is wrong

**Explanation:** The 'age' property should be indented under 'user' or moved to the same level

---

## Question 7
**How do you reference an environment variable in YAML?**

- A) ${VARIABLE_NAME} ✅
- B) $VARIABLE_NAME
- C) {VARIABLE_NAME}
- D) ENV(VARIABLE_NAME)

**Explanation:** Environment variables are referenced using ${VARIABLE_NAME} syntax

---

## Question 8
**Complete the YAML anchor and alias example:**

```yaml
defaults: ___default
  image: node:18
  restart: unless-stopped

web:
  ___: *default
  ports:
    - "3000:3000"
```

**Answer:** 
```yaml
defaults: &default
  image: node:18
  restart: unless-stopped

web:
  <<: *default
  ports:
    - "3000:3000"
```

---

## Question 9
**What is the difference between | and > in YAML?**

- A) | preserves line breaks, > folds lines ✅
- B) | folds lines, > preserves line breaks  
- C) Both do the same thing
- D) | is for arrays, > is for objects

**Explanation:** | (literal) preserves line breaks, > (folded) converts line breaks to spaces

---

## Question 10
**Which data type is this: `port: 3000`**

- A) String
- B) Integer ✅
- C) Float
- D) Boolean

**Explanation:** 3000 without quotes is interpreted as an integer

---

## Question 11
**Fix the syntax error in this YAML:**

```yaml
services:
  web:
    image nginx:alpine
    ports:
      - 80:80
```

**Answer:**
```yaml
services:
  web:
    image: nginx:alpine  # Missing colon
    ports:
      - "80:80"  # Should be quoted
```

---

## Question 12
**What does this YAML represent?**

```yaml
matrix:
  - [1, 2, 3]
  - [4, 5, 6]
  - [7, 8, 9]
```

- A) A 3x3 matrix ✅
- B) Three separate arrays
- C) Invalid YAML syntax
- D) A configuration error

**Explanation:** This creates an array of arrays, representing a 3x3 matrix

---

## Question 13
**Complete the YAML to create multiple documents:**

```yaml
name: Document 1
type: config
___
name: Document 2
type: data
```

**Answer:** `---` (three dashes separate YAML documents)

---

## Question 14
**What is the correct way to represent null in YAML?**

- A) null ✅
- B) ~ ✅
- C) NULL ✅  
- D) All of the above ✅

**Explanation:** YAML supports multiple representations for null values

---

## Question 15
**Practical Challenge: Create a YAML configuration for a web application**

**Requirements:**
- Application name: "MyWebApp"
- Version: 1.0.0
- Database configuration with host, port, and credentials
- Feature flags for debugging and logging
- Environment-specific settings

**Sample Answer:**
```yaml
app:
  name: "MyWebApp"
  version: "1.0.0"

database:
  host: ${DB_HOST:-localhost}
  port: ${DB_PORT:-5432}
  username: ${DB_USER:-admin}
  password: ${DB_PASSWORD}

features:
  debug: false
  logging: true
  analytics: true

environments:
  development:
    debug: true
    log_level: debug
  production:
    debug: false
    log_level: info
```

---

## 🎯 Quiz Results

### Scoring Breakdown:
- **Questions 1-10:** 50 points each (500 total)
- **Questions 11-14:** 75 points each (300 total)
- **Question 15 (Practical):** 200 points
- **Total Possible:** 1000 points

### Achievement Levels:
- 🥉 **Bronze (700+):** Good understanding of YAML basics
- 🥈 **Silver (850+):** Strong grasp of YAML concepts  
- 🥇 **Gold (950+):** Excellent YAML proficiency
- ⭐ **Platinum (1000):** YAML master!

### Next Steps:
- **Bronze:** Review the [YAML Guide](../../basics/) and retake quiz
- **Silver:** Move to [Docker Fundamentals Quiz](./docker-fundamentals.md)
- **Gold:** Ready for [Foundation Assessment](./foundation-assessment.md)
- **Platinum:** Advance to Intermediate Track!

### Study Resources:
- 📚 [YAML Basics](../../basics/hello.yaml)
- 📚 [Advanced YAML](../../basics/advanced.yaml)
- 📚 [Configuration Patterns](../../basics/config.yaml)
- 🎥 [YAML Tutorial Video](https://youtube.com/docker-yaml-mastery/yaml-basics)

**Ready for the next challenge?** Take the [Docker Fundamentals Quiz](./docker-fundamentals.md)!
