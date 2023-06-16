#!/bin/bash
set -ex

PRESTO_CMD="$1"

case ${PRESTO_CMD} in
  coordinator)
    cp /usr/local/presto-server-0.234.2/etc/config-coordinator.properties /usr/local/presto-server-0.234.2/etc/config.properties
    sed -i "s/{port}/${PRESTO_COORDINATOR_PORT}/g" /usr/local/presto-server-0.234.2/etc/config.properties
    sed -i "s/{maxMemoryPerNode}/${PRESTO_COORDINATOR_MAX_MEMORY_PER_NODE}/g" /usr/local/presto-server-0.234.2/etc/config.properties
    sed -i "s/{maxTotalMemoryPerNode}/${PRESTO_COORDINATOR_MAX_TOTAL_MEMORY_PER_NODE}/g" /usr/local/presto-server-0.234.2/etc/config.properties
    sed -i "s/{maxMemory}/${PRESTO_COORDINATOR_MAX_MEMORY}/g" /usr/local/presto-server-0.234.2/etc/config.properties
    sed -i "s/{jvm_memory}/${PRESTO_COORDINATOR_JVM_MEMORY}/g" /usr/local/presto-server-0.234.2/etc/jvm.config
    ;;
   worker)
    cp /usr/local/presto-server-0.234.2/etc/config-worker.properties /usr/local/presto-server-0.234.2/etc/config.properties
    sed -i "s/{prestoCoordinatorUrl}/${PRESTO_COORDINATOR_URL}/g" /usr/local/presto-server-0.234.2/etc/config.properties
    sed -i "s/{port}/${PRESTO_WORKER_PORT}/g" /usr/local/presto-server-0.234.2/etc/config.properties
    sed -i "s/{maxMemoryPerNode}/${PRESTO_WORKER_MAX_MEMORY_PER_NODE}/g" /usr/local/presto-server-0.234.2/etc/config.properties
    sed -i "s/{maxTotalMemoryPerNode}/${PRESTO_WORKER_MAX_TOTAL_MEMORY_PER_NODE}/g" /usr/local/presto-server-0.234.2/etc/config.properties
    sed -i "s/{maxMemory}/${PRESTO_WORKER_MAX_MEMORY}/g" /usr/local/presto-server-0.234.2/etc/config.properties
    sed -i "s/{jvm_memory}/${PRESTO_WORKER_JVM_MEMORY}/g" /usr/local/presto-server-0.234.2/etc/jvm.config
;;
esac

NODE_ID=$(uuidgen)

sed -i "s/{nodeId}/${NODE_ID}/g" /usr/local/presto-server-0.234.2/etc/node.properties
sed -i "s/{env}/${ENV}/g" /usr/local/presto-server-0.234.2/etc/node.properties

sed -i "s/{awsUseInstanceCredentials}/${AWS_USE_INSTANCE_CREDENTIALS}/g" /usr/local/presto-server-0.234.2/etc/catalog/my_hive.properties
sed -i "s/{awsAccessKey}/${AWS_ACCESS_KEY}/g" /usr/local/presto-server-0.234.2/etc/catalog/my_hive.properties
sed -i "s/{awsSecretKey}/${AWS_SECRET_KEY}/g" /usr/local/presto-server-0.234.2/etc/catalog/my_hive.properties
sed -i "s/{metastoreUrl}/${HIVE_METASTORE_URL}/g" /usr/local/presto-server-0.234.2/etc/catalog/my_hive.properties

cd "/usr/local/presto-server-0.234.2" && bin/launcher run