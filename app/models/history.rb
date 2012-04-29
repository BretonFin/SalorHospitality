# coding: UTF-8

# BillGastro -- The innovative Point Of Sales Software for your Restaurant
# Copyright (C) 2012-2013  Red (E) Tools LTD
# 
# See license.txt for the license applying to all files within this software.
class History < ActiveRecord::Base
  belongs_to :user
  belongs_to :model, :polymorphic => true
  before_create :set_fields
  def set_fields
    if $User then
      self.user = $User
    end
    self.url = $Request.url if $Request
    self.params = $Params.to_json if $Params
    self.ip = $Request.ip if $Request
  end
  def self.record(action,object,sen=5)
    # sensitivity is from 5 (least sensitive) to 1 (most sensitive)
    h = History.new
    h.sensitivity = sen
    h.model = object if object
    h.action_taken = action
    if object and object.respond_to? :changes then
      h.changes_made = object.changes.to_json
    end
    h.save
  end
end
