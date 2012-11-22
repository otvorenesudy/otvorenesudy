module JudgesHelper
  def link_to_judge(judge)
    link_to judge.name, judges_path(judge.id)
  end
end
