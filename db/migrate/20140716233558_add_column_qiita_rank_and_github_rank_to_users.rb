class AddColumnQiitaRankAndGithubRankToUsers < ActiveRecord::Migration
  def change
    add_column :users, :qiita_rank, :float
    add_column :users, :github_rank, :float
    add_index :users, :qiita_rank
    add_index :users, :github_rank
  end
end
