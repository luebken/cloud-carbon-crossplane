#!/bin/bash
# https://github.com/cloud-carbon-footprint/cloud-carbon-coefficients/blob/main/data/grid-emissions-factors-aws.csv
echo "" > ../crds/compositions.yaml

while IFS=, read -r region co2e category
do
    echo "$region and $co2e and $category"

echo "---
apiVersion: apiextensions.crossplane.io/v1
kind: Composition
metadata:
  name: xbuckets.$region.aws.storage.cloudcarbonfootprint.org
  labels:
    carbon-footprint: $category
    co2e: \"$co2e\"
    provider: aws
spec:
  compositeTypeRef:
    apiVersion: storage.cloudcarbonfootprint.org/v1alpha1
    kind: XBuckets
  resources:
    - name: bucket
      base:
        apiVersion: s3.aws.crossplane.io/v1beta1
        kind: Bucket
        spec:
          forProvider:
            acl: public-read-write
            locationConstraint: $region
      patches:
        - type: ToCompositeFieldPath
          fromFieldPath: status.atProvider.arn
          toFieldPath: status.arn" >> ../crds/compositions.yaml
done < aws.csv