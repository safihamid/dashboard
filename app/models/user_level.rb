class UserLevel < ActiveRecord::Base
  belongs_to :user
  belongs_to :level

  def best?
    return false if best_result.nil?
    (best_result == Activity::BEST_PASS_RESULT)
  end

  def finished?
    return false if best_result.nil?
    (best_result >= Activity::MINIMUM_FINISHED_RESULT)
  end

  def passing?
    return false if best_result.nil?
    (best_result >= Activity::MINIMUM_PASS_RESULT)
  end
end
