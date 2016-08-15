# frozen_string_literal: true
class User < ApplicationRecord
  has_many :posts
  has_many :comments
  has_and_belongs_to_many :roles

  def datetime_format
    "%d/%m/%y %H:%M"
  end

  def created
    created_at.strftime(datetime_format)
  end

  def updated
    updated_at.strftime(datetime_format)
  end

  # Whitelist the User model attributes for sorting, except +password_digest+.
  #
  # The +full_name+ ransacker is also not included because error-prone in SQL
  # ORDER clauses and provided no additional functionality over +first_name+.
  #
  def self.ransortable_attributes(auth_object = nil)
    column_names - ['password_digest']
  end

  ransacker :full_name do |parent|
    Arel::Nodes::InfixOperation.new('||',
      Arel::Nodes::InfixOperation.new('||',
        parent.table[:first_name], Arel::Nodes.build_quoted(' ')),
      parent.table[:last_name])
  end
end
