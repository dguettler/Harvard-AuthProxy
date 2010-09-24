require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PinLoginController do

  describe "validate" do
    describe "with valid session" do
      before(:each) do
        @user = stub_model(Site::User)
        Site::User.stub!(:find_by_first_name_and_last_name).and_return(@user)
        @session = mock_model(PinSession, { :valid? => true, :user_id => @user.id })
      end

      it "should set user_id and redirect to root_path" do
        PinSession.should_receive(:new).and_return(@session)
        get :validate, :_azp_token => 'my_token'
        response.should redirect_to(root_path)
        session[:user_id].should == @user.id
      end
    end

    describe "with invalid session" do
      before(:each) do
        @user = stub_model(Site::User)
        Site::User.stub!(:find_by_first_name_and_last_name).and_return(@user)
        @session = mock_model(PinSession, { :valid? => false, :user_id => @user.id })
      end

      it "should not set user_id and redirect to access_denied" do
        PinSession.should_receive(:new).and_return(@session)
        get :validate, :_azp_token => 'my_token'
        response.should redirect_to(access_denied_path)
        session[:user_id].should be_nil
      end
    end
  end

end
