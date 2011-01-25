require 'test_helper'

class IcdCodesControllerTest < ActionController::TestCase
  setup do
    @icd_code = icd_codes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:icd_codes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create icd_code" do
    assert_difference('IcdCode.count') do
      post :create, :icd_code => @icd_code.attributes
    end

    assert_redirected_to icd_code_path(assigns(:icd_code))
  end

  test "should show icd_code" do
    get :show, :id => @icd_code.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @icd_code.to_param
    assert_response :success
  end

  test "should update icd_code" do
    put :update, :id => @icd_code.to_param, :icd_code => @icd_code.attributes
    assert_redirected_to icd_code_path(assigns(:icd_code))
  end

  test "should destroy icd_code" do
    assert_difference('IcdCode.count', -1) do
      delete :destroy, :id => @icd_code.to_param
    end

    assert_redirected_to icd_codes_path
  end
end
