module GroupsHelper
  def get_privacy_list
    get_list('rep_privacy')
  end

  def get_group_list
    get_list('rep_group')
  end

  def get_list(list_name)
    ActsAsTaggableOn::Tagging.find_all_by_context(list_name).collect {|tg| tg.tag }.uniq
  end
end
