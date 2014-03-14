#encoding: utf-8

require 'spec_helper'

describe 'user' do
  before :all do
    @usergroup = gen_name 'usergroup'
    @usergroupid = zbx.usergroups.create(:name => @usergroup)

    @mediatype = gen_name 'mediatype'
    @mediatypeid = zbx.mediatypes.create(
      :description => @mediatype,
      :type => 0,
      :smtp_server => "127.0.0.1",
      :smtp_email => "zabbix@test.com"
    )
  end

  context 'when not exists' do
    describe 'create' do
      it "should return integer id" do
        user = gen_name 'user'
        userid = zbx.users.create(
          :alias => "Test #{user}",
          :name => user,
          :surname => user,
          :passwd => user,
          :usrgrps => [@usergroupid]
        )
        userid.should be_kind_of(Integer)
      end
    end

    describe 'get_id' do
      it "should return nil" do
        zbx.users.get_id(:name => "name_____").should be_nil
      end
    end
  end

  context 'when exists' do
    before :all do
      @user = gen_name 'user'
      @userid = zbx.users.create(
        :alias => @user,
        :name => @user,
        :surname => @user,
        :passwd => @user,
        :usrgrps => [@usergroupid]
      )
    end

    describe 'create_or_update' do
      it "should return id" do
        zbx.users.create_or_update(
          :alias => @user,
          :name => @user,
          :surname => @user,
          :passwd => @user
        ).should eq @userid
      end
    end

    describe 'get_full_data' do
      it "should return string name" do
        zbx.users.get_full_data(:name => @user)[0]['name'].should be_kind_of(String)
      end
    end

    describe 'update' do
      it "should return id" do
        zbx.users.update(:userid => @userid, :name => gen_name('user')).should eq @userid
      end
    end

    describe 'add_medias' do
      it "should return integer media id" do
        zbx.users.add_medias(
          :userids => [@userid],
          :media => [
            {
              :mediatypeid => @mediatypeid,
              :sendto => "test@test",
              :active => 0,
              :period => "1-7,00:00-24:00",
              :severity => "56"
            }
          ]
        ).should be_kind_of(Integer)
      end
    end

    describe 'delete' do
      it "should return id" do
        zbx.users.delete(@userid).should eq @userid
      end
    end
  end
end
