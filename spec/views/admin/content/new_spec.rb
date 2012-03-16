require 'spec_helper'

describe "admin/content/new.html.erb" do
  before do
    admin = stub_model(User, :settings => {:editor => 'simple'}, :admin? => true,
                       :text_filter_name => "", :profile_label => "admin")
    blog = mock_model(Blog, :base_url => "http://myblog.net/")
    article = stub_model(Article).as_new_record
    text_filter = stub_model(TextFilter)

    article.stub(:text_filter) { text_filter }
    view.stub(:current_user) { admin }
    view.stub(:this_blog) { blog }
    
    # FIXME: Nasty. Controller should pass in @categories and @textfilters.
    Category.stub(:all) { [] }
    TextFilter.stub(:all) { [text_filter] }

    assign :article, article
  end

  it "renders with no resources or macros" do
    assign(:images, [])
    assign(:macros, [])
    assign(:resources, [])
    render
  end

  it "renders with image resources" do
    # FIXME: Nasty. Thumbnail creation should not be controlled by the view.
    img = mock_model(Resource, :filename => "foo", :create_thumbnail => nil)
    assign(:images, [img])
    assign(:macros, [])
    assign(:resources, [])
    render
  end

  before do
    assign(:images, [])
    assign(:macros, [])
    assign(:resources, [])
  end

  it "renders a header tag titled Merge if user is an admin" do
    render
    rendered.should have_selector("h4", :content=>"Merge")
  end

  it "renders the merge articles partial if user is an admin" do
    render
    rendered.should render_template(:partial => "admin/content/_merge")
  end

  it "should not render a header tag titled Merge if user is a non-admin" do
    non_admin = stub_model(User, :settings => {:editor => 'simple'}, :admin? => false)
    view.stub(:current_user) {non_admin}
    render
    rendered.should_not have_selector("h4", :content=>"Merge")
  end

  it "should not render the merge articles partial if user is a non-admin" do
    non_admin = stub_model(User, :settings => {:editor => 'simple'}, :admin? => false)
    view.stub(:current_user) {non_admin}
    render
    render.should_not render_template(:partial => "admin/content/_merge")
  end

end
