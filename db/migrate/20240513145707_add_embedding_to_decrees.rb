class AddEmbeddingToDecrees < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE EXTENSION IF NOT EXISTS vector;

      ALTER TABLE decrees ADD COLUMN embedding vector(768);

      CREATE INDEX ON decrees USING hnsw (embedding vector_cosine_ops) WITH (m = 20, ef_construction = 64);
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE decrees DROP COLUMN embedding;

      DROP EXTENSION IF EXISTS vector;
    SQL
  end
end
