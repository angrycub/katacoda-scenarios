Levant is an open source templating and deployment tool for HashiCorp Nomad jobs
that provides realtime feedback and detailed failure messages upon deployment
issues.

While Levant is designed to facilitate job templating and deployment to Nomad,
this tutorial will focus on the basics of template rendering and teach using
components that do not require Nomad or Consul to be installed. 

Future tutorials will explore consolidating the skills generated in this
tutorial with Nomad and Consul to create powerful and maintainable application
templates.

This tutorial will explore building templates for Levant and using Levant
to render them out. You will learn how to:

- Install Levant and render your first template—hello levant.

- Use template variables:
    - functional variables
    - command-line variables
    - file-variables

- Manipulate strings
    - toUpper/toLower
    - replace

- Iterate over a collection

- Include files into a template

- Use sub-templates

- Combine these skills
