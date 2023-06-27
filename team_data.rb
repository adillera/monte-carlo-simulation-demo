module TeamData
  def throughput
    %w(0 2 1 0 0 0 1 0 0 1).map(&:to_i)
  end

  def hotfix
    %w(0 1 1 0 0 0 0 0 0 0).map(&:to_i)
  end
end
