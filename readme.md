# Cloud Carbon Crossplane

## Use-Case
As an application developer I would like run my S3 buckets with a low carbon footprint because it's the right thing to-do. Sure here you go: 
```yaml
cat <<EOF | kubectl apply -f -
apiVersion: storage.cloudcarbonfootprint.org/v1alpha1
kind: Bucket
metadata:
  namespace: default
  name: my-low-carbon-bucket
spec:
  compositionSelector:
    matchLabels:
      carbon-footprint: very-low
EOF

kubectl get buckets my-low-carbon-bucket
NAME                   ARN                                             CO2E          READY   CONNECTION-SECRET   AGE
my-low-carbon-bucket   arn:aws:s3:::my-low-carbon-bucket-123-123       0.000008000   True                        10m
```

## How it Works
In a naive implementation, the platform team could provide [several compositions](crds/compositions.yaml) which have a `co2e` value based on [cloud-carbon-coefficients](https://github.com/cloud-carbon-footprint/cloud-carbon-coefficients/tree/main/data) and `carbon-footprint` property with basic categories like `very-low`, `low`, `medium` and `high` based on the `co2e` value. The label `carbon-footprint` can than be used as a composition selector and the `co2e` value could be served for verification and analysis.

A more advanced version could allow weighted factors between region and cloud-carbon-coefficients and possibly other properties. In the end, the platform should optimize for low carbon footprint per default.

## Naive implementation

Pre-requiste: Have [Crossplane](https://crossplane.io/docs/v1.5/) installed with AWS configured.

```sh
# Install the XRD which defines the schema of our new type
kubectl create -f crds/xrd.yaml
# Verify
kubectl get xrds
NAME                                        ESTABLISHED   OFFERED   AGE
xbuckets.storage.cloudcarbonfootprint.org   True          True      107s


# Install the Compositions which have the CO2e and a carbon-footprint category
kubectl create -f crds/compositions.yaml
# Verify
kubectl get compositions
NAME                                                           AGE
xbuckets.ap-east-1.aws.storage.cloudcarbonfootprint.org        8s
xbuckets.ap-northeast-1.aws.storage.cloudcarbonfootprint.org   8s
xbuckets.ap-northeast-2.aws.storage.cloudcarbonfootprint.org   8s
...

# Install the Claim requesting a bucket with a low carbon foot-print:
kubectl create -f crds/claim-low.yaml

# Verify the Bucket
kubectl get buckets
NAME                   ARN                                             CO2E          READY   CONNECTION-SECRET   AGE
my-low-carbon-bucket   arn:aws:s3:::my-low-carbon-bucket-123-123       0.000008000   True                        39s

# Show the ARN:
kubectl get bucket.storage.cloudcarbonfootprint.org/my-aws-bucket -o json | jq .status.arn
```

## Related work
* https://www.thoughtworks.com/de-de/radar/tools/cloud-carbon-footprint
* https://github.com/thegreenwebfoundation/green-cost-explorer
* https://github.com/cloud-carbon-footprint/cloud-carbon-coefficients/blob/main/data/grid-emissions-factors-gcp.csv
* https://github.com/Green-Software-Foundation/awesome-green-software
* https://github.com/kubernetes-sigs/controller-runtime/blob/master/pkg/client/options.go
https://github.com/crossplane/crossplane/blob/master/internal/controller/apiextensions/composite/api.go#L256