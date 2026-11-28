#!/usr/bin/env ruby
# frozen_string_literal: true

require "fileutils"

ROOT = File.expand_path("..", __dir__)
POSTS_DIR = File.join(ROOT, "_posts")
MESSAGES_DIR = File.join(ROOT, "_messages")
SITE_URL = "https://www.catxcoder.com"

def front_matter(source)
  match = source.match(/\A---\s*\r?\n(.*?)\r?\n---\s*\r?\n/m)
  return {} unless match

  match[1].each_line.each_with_object({}) do |line, data|
    key, value = line.split(":", 2)
    next unless value

    data[key.strip] = value.strip.sub(/\A["']/, "").sub(/["']\z/, "")
  end
end

def post_details(path)
  source = File.read(path, encoding: "bom|utf-8")
  data = front_matter(source)
  source_filename = File.basename(path)
  jekyll_basename = File.basename(path, File.extname(path))
  message_basename = source_filename.sub(/(?:\.md|\.markdown)+\z/i, "")
  date_match = jekyll_basename.match(/\A(\d{4})-(\d{1,2})-(\d{1,2})-(.+)\z/)
  raise "Cannot parse post filename: #{path}" unless date_match

  display_title = data.fetch("title").sub(/\A\[Leetcode解題\]\s*/, "")
  display_title = display_title.split(/\s+-\s+/, 2).first
  problem_id = display_title[/\d+/] || jekyll_basename[/-(\d+)(?:\D|$)/, 1]
  category = data.fetch("categories").split.first
  description = data.fetch("description", "")
  summary = description.split(/\s+-\s+/, 2)[1] || description
  summary = "從題目條件整理出合適的演算法" if summary.strip.empty?
  leetcode_url = source[%r{https://leetcode\.com/problems/[^\s\)\]，]+}]
  leetcode_url ||= "https://leetcode.com/problemset/"

  year, month, day, slug = date_match.captures
  article_url = [SITE_URL, category, year, format("%02d", month.to_i), format("%02d", day.to_i), "#{slug}.html"].join("/")

  {
    basename: message_basename,
    display_title: display_title,
    problem_id: problem_id,
    summary: summary.sub(/[。！？!]+\z/, ""),
    leetcode_url: leetcode_url,
    article_url: article_url
  }
end

def message_content(post)
  summary = post[:summary]
  explanation = if summary.match?(/\A(?:使用|利用|透過|將|先|以|從|建立|排序|枚舉|把|結合)/)
                  "這題可以#{summary}"
                elsif summary.match?(/解(?:法)?\z/)
                  "這題可以用#{summary}"
                else
                  "這題的解法重點是#{summary}"
                end

  <<~MESSAGE
    # #{post[:display_title]}

    ## Message 1: 本週挑戰題
    📢 本週挑戰題：#{post[:display_title]} (#{post[:leetcode_url]})，大家有空可以挑戰看看!

    ## Message 2: 上週挑戰題解析
    📢上週挑戰題解析
    讓我們一起來看看上週挑戰題 #{post[:display_title]}，#{explanation}，詳細可以參考 #{post[:article_url]}
  MESSAGE
end

FileUtils.mkdir_p(MESSAGES_DIR)
posts = Dir.children(POSTS_DIR)
           .select { |name| %w[.md .markdown].include?(File.extname(name).downcase) }
           .sort
           .map { |name| File.join(POSTS_DIR, name) }

posts.each do |path|
  post = post_details(path)
  output_path = File.join(MESSAGES_DIR, "#{post[:basename]}.txt")
  File.write(output_path, message_content(post), mode: "w", encoding: "utf-8")
end

puts "Generated #{posts.length} social message files in #{MESSAGES_DIR}"
