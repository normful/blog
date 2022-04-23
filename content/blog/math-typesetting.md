+++
title = "KaTeX Usage"
date = 2021-05-03T09:19:42+00:00
updated = 2021-05-03T09:19:42+00:00
draft = false

[taxonomies]
tags = ["math"]

[extra]
katex = true
+++

```bash
{% if page.extra.katex or section.extra.katex or config.extra.katex %}
  {% include 'katex.html' %}
{% endif %}
```

See [Supported TeX Functions](https://katex.org/docs/supported.html)

### Examples

<p>
Inline math: \(\varphi = \dfrac{1+\sqrt5}{2}= 1.6180339887…\) 
</p>

Block math:
$$
 \varphi = 1+\frac{1} {1+\frac{1} {1+\frac{1} {1+\cdots} } } 
$$
