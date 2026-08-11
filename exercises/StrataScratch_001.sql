-- Find all posts which were reacted to with a heart
-- Find all posts which were reacted to with a heart. For such posts output all columns from facebook_posts table.

select * 
from facebook_posts as fp
left join facebook_reactions as fr
on fp.post_id = fr.post_id
where fr.reaction = 'heart';
