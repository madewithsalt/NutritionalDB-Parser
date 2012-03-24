# Reference to data field formats inside DB files, to parse into JSON
# Values are taken from the documentation supplied with the database from ndb.nal.usda.gov

class Formats
 @@db_formats = {
    data_src: %w(
      'DataSrc_ID'
      'Authors'
      'Title'
      'Year'
      'Journal'
      'Vol_City'
      'Issue_State'
      'Start_Page'
      'End_Page'
    ),

    datsrcln: %w(
      'NDB_No'
      'Nutr_No'
      'DataSrc_ID'
    ),

    footnote: %w(
      'NDB_No'
      'Footnt_No'
      'Footnt_Typ'
      'Nutr_No'
      'Footnt_Txt'
    ),

    weight: %w(
      'NDB_No'
      'Seq'
      'Amount'
      'Msre_Desc'
      'Gm_Wqt'
      'Num_Data_Pts'
      'Std_Dev'
    ),

    deriv_cd: %w(
      'Deriv_Cd'
      'Deriv_Desc'
    ),

    src_cd: %w(
      'Src_Cd'
      'SrcCd_Desc'
    ),

    nutr_def: %w(
      'Nutr_No'
      'Units'
      'Tagname'
      'NutrDesc'
      'Num_Dec'
      'SR_Order'
    ),

    # The big Kahuna!
    nut_data: %w(
      'NDB_No'
      'Nutr_No'
      'Nutr_Val'
      'Num_Data_Pts'
      'Std_Error'
      'Src_Cd'
      'Deriv_Cd'
      'Ref_NDB_No'
      'Add_Nutr_Mark'
      'Num_Studies'
      'Min'
      'Max'
      'DF'
      'Low_EB'
      'Up_EB'
      'Stat_cmt'
      'CC'
    ),

    fd_group: %w(
      'FdGrp_Cd'
      'FdGrp_Desc'
    ),

    food_des: %w(
      'NDB_No'
      'FdGrp_Cd'
      'Long_Desc'
      'Shrt_Desc'
      'ComName'
      'ManufacName'
      'Survey'
      'Ref_desc'
      'Refuse'
      'SciName'
      'N_Factor'
      'Pro_Factor'
      'Fat_Factor'
      'CHO_Factor'
    )
  }

  def get_format_hash
    return @@db_formats
  end
end
