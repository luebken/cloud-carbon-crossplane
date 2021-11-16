# Cloud Carbon Crossplane

## Use-Case
As an application developer 
I would like to have my infrastructure optimized for low carbon footprint
because it's the right thing to-do.

## How it Works**
In a naive implementation, the platform team could provide several XRs which have a `carbon-footprint` label available as a composition selector. They could start with `low`, `medium`, `high` category based on the [cloud-carbon-coefficients](https://github.com/cloud-carbon-footprint/cloud-carbon-coefficients/tree/main/data). 

A more advanced would allow weighted factors between region and cloud-carbon-coefficients and possibly other properties. In the end, the platform should optimize for low carbon footprint per default.

## Naive implementation

Pre-requiste: Have [Crossplane](https://crossplane.io/docs/v1.5/) installed with AWS configured.

```sh
# Install the XRD
kubectl create -f xrd.yaml
# Verify
kubectl get xrds
NAME                                        ESTABLISHED   OFFERED   AGE
xbuckets.storage.cloudcarbonfootprint.org   True          True      107s

# Install the Composition
kubectl create -f compositions.yaml
# Verify
kubectl get compositions
NAME                                                     AGE
xbuckets.high-co2.aws.storage.cloudcarbonfootprint.org   13s
xbuckets.low-co2.aws.storage.cloudcarbonfootprint.org    13s

# Install the Claim
kubectl create -f claim.yaml

# Verify XR and Bucket
kubectl get managed,buckets
NAME                                                           READY   SYNCED   AGE
bucket.s3.aws.crossplane.io/my-low-carbon-bucket-fq7th-bk2fx   True    True     25s

NAME                                                           READY   CONNECTION-SECRET   AGE
bucket.storage.cloudcarbonfootprint.org/my-low-carbon-bucket   False                       25s
```

## Related work
* https://www.thoughtworks.com/de-de/radar/tools/cloud-carbon-footprint
* https://github.com/thegreenwebfoundation/green-cost-explorer
* https://github.com/cloud-carbon-footprint/cloud-carbon-coefficients/blob/main/data/grid-emissions-factors-gcp.csv