defmodule PoolWatch.Query.CommonFields do
  def stake_pool_fields() do
    "
      hash,
      url,
      metadataHash,
      pledge,
      margin,
      fixedCost,
      rewardAddress,
      fixedCost
    "
  end

  def block_fields() do
    "
      number
      epochNo,
      slotNo,
      forgedAt,
      fees,
      opCert,
      slotInEpoch,
      size,
      transactionsCount,
      vrfKey
    "
  end

  def block_with_stake_pool() do
    "#{block_fields()},
      slotLeader{
        hash,
        description,
        stakePool{
          #{stake_pool_fields()}
        }
    }"
  end
end
