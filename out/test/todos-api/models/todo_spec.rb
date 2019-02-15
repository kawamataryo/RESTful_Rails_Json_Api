require 'rails_helper'

RSpec.describe Todo, type: :model do
  describe "relationship" do
    it { should have_many(:items).dependent(:destroy) }
  end
end
