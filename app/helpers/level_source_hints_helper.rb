module LevelSourceHintsHelper
  def build_add_hint_path(idx, pop_level_source_ids)
    if idx.nil? || idx < 0 || pop_level_source_ids.nil? || idx > pop_level_source_ids.length - 1
      nil
    else
      add_hint_path(pop_level_source_ids[idx], :idx => idx, :pop_level_source_ids => pop_level_source_ids)
    end
  end
end
