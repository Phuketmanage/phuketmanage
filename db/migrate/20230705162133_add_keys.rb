class AddKeys < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key "bookings", "sources", name: "bookings_source_id_fk"
    add_foreign_key "empl_types_job_types", "empl_types", name: "empl_types_job_types_empl_type_id_fk"
    add_foreign_key "empl_types_job_types", "job_types", name: "empl_types_job_types_job_type_id_fk"
    add_foreign_key "employees_houses", "employees", name: "employees_houses_employee_id_fk"
    add_foreign_key "employees_houses", "houses", name: "employees_houses_house_id_fk"
    add_foreign_key "houses_locations", "houses", name: "houses_locations_house_id_fk"
    add_foreign_key "houses_locations", "locations", name: "houses_locations_location_id_fk"
    add_foreign_key "roles_users", "roles", name: "roles_users_role_id_fk"
    add_foreign_key "roles_users", "users", name: "roles_users_user_id_fk"
  end
end
