require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "relationship" do
    it { should have_many(:items).dependent(:destroy) }
  end
end
