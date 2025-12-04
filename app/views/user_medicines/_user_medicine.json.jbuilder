json.extract! user_medicine, :id, :medicine_name, :dosage_per_time, :prescribed_amount, :current_stock, :date_of_prescription, :user_id, :created_at, :updated_at
json.url user_medicine_url(user_medicine, format: :json)
