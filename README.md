# surveygenmod2

surveygenmod2 is an extension and modification of the %surveygenmod macro for SAS by da Silva (2017) for estimating generalized linear models under complex sampling designs.

We could not find an easily accessible approach to estimating generalized linear models under complex samplings designs in SAS except for the macro by da Silva (2017). 
However, the code was very difficult to work with as it was posted as part of the proceedings of a SAS Global Forum paper on a PDF.
Moving from the PDF to SAS was a significant and painstaking amount of work for Y. Chen and myself (R.N. Padgett) because we ended up having to go line by line through the macro.
We added several additional features including, but not limited to:

- exportable parameter variance-covariance matrix,
- exportable significant tests of parameters, and
- minor bug fixes.

When refering this macro, please cite both da Silva (2017)'s original work and our ArXiv whitepaper (Padgett & Chen, 2024).

Chen and I needed a relatively fast approximation for GLM's under complex sampling designs for our work on the Global Flourishing Study (GFS; Johnson et al., 2024).
The GFS core team was coordinating over 90+ papers to analyze the Wave 1 data resulting from the international study of well-being, and the analyses were to be conducted by individual research teams within the project.
We needed a fast approximation of GLM's so that computational resources weren't bogged down trying to estimate a single model within a single country's sample.
Implementations for estimating parameter variances using replicate weights are generally more precise, but were found to be significantly more computationally intensive given the sample sizes of the GFS. Prohibiting the utility of these methods.
The macro by da Silva (2017) provided us the much needed groundwork for a Taylor series approximation of the parameter variance-covariance matrix.

## Sample Code and Data

The sample data used from the Global Flourishing Study were subset and perturbed compared to the full dataset. This subset of data are available in the object "sample-code/sample_data.Rds". The data can be accessed via R and resaved as a CSV file for use in SAS.

```
sample_data <- readRDS("sample_data.Rds")

write.csv(sample_data, file="sample_data.csv", rownames=FALSE)
```

The folder "sample-code" also contains an example script for use in SAS along with the code for using the Wald-type test on a subset of regression coefficients.

## References

da Silva, A. R. (2017). %SURVEYGENMOD Macro: An Alternative to Deal with Complex Survey Design for the GENMOD Procedure (Paper 268-2017). SAS Global Forum. [Retrieve on [2024-05-17] from https://support.sas.com/resources/papers/proceedings17/0268-2017.pdf]

Johnson, B. R., Ritter, Z., Fogleman, A., Markham, L., Stankov, T., Srinivasan, R., Honohan, J., Ripley, A., Philips, T., Wang, H., & VanderWeele, T. J. (2024). The Global Flourishing Study. https://doi.org/10.17605/OSF.IO/3JTZ8

Padgett, R. N., Bradshaw, M., Chen, Y., Jang, S. J., Shiba, K., Johnson, B. R., & VanderWeele, T. J. (2024). Global Flourishing Study Statistical Analyses Code. Center for Open Science, [Retrieve from https://osf.io/vbype/]

Padgett, R. N., & Chen, Y. (2024). surveygenmod2: A SAS macro for estimating generalized linear model and conducting simple Wald-type tests under complex survey designs. ArXiv. https://arxiv.org/abs/2406.07651
