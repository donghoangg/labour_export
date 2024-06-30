USE labour_export;
--Câu 10: Tìm thông tin về các công ty nước ngoài đang có labor gặp vấn đề, số lượng labour gặp vấn đề
SELECT
    W_i.company_id,
    C.company_name,
    count(W_i.worker_id) as quantity
FROM abroad.company C
    Join abroad.worker_information as W_i on W_i.company_id=C.company_id
    Join abroad.worker_problem P on P.worker_id=W_i.worker_id
GROUP BY  W_i.company_id, C.company_name
ORDER BY count(W_i.worker_id) DESC



--câu 6 tìm tỷ lệ phần trăm của số lượng công nhân từng độ tuổi trong labor
select 
    worker_age,
    count(worker_id) as num_worker,
    round((count(worker_id) * 100.0  / (
select count(worker_id) from abroad.worker_information)), 4) as age_percentage
from abroad.worker_information
group by worker_age
ORDER by worker_age
    

--Câu 9 Tìm kiếm khoảng thời gian ( recuiment time ) tuyển được nhiều người nhất
--(xác định được nhu cầu tuyển dụng trong 1 năm là nhiều nhất ở thời gian nào)

SELECT r.recruitment_id,
    r.recruitment_beginTime,
    r.recruitment_endTime,
    COUNT(si.student_id) AS total_students
FROM abroad.recruitment r
    JOIN abroad.job j ON r.job_id = j.job_id
    JOIN student.information si ON r.recruitment_id = si.recruitment_id
GROUP BY r.recruitment_id, r.recruitment_beginTime, r.recruitment_endTime
HAVING COUNT(si.student_id) = (
    SELECT MAX(student_count)
FROM (
        SELECT COUNT(si.student_id) AS student_count
    FROM abroad.recruitment r
        JOIN student.information si ON r.recruitment_id = si.recruitment_id
    GROUP BY r.recruitment_id
    ) AS max_students
)
ORDER BY total_students DESC;


--Câu 8: Tìm tỷ lệ phần trăm của số lượng công nhân từng độ tuổi trong Labor
SELECT
    worker_age,
    COUNT(worker_id) AS num_workers,
    ROUND((COUNT(worker_id) * 100.0 / (SELECT COUNT(worker_id)
    FROM abroad.worker_information)), 4) AS percentage
FROM
    abroad.worker_information
GROUP BY 
    worker_age
ORDER BY 
    worker_age;


--câu 7 Trung bình độ tuổi và số lượng người lao động với mỗi ngành nghề tại Nhật Bản. 

SELECT  

    job.job_id, 

    job.job_name, 

    avg(awi.worker_age* 1.0), 

    count(awi.worker_id) 
FROM abroad.worker_information as awi 
            join abroad.job as job on awi.job_id = job.job_id 

GROUP BY job.job_id, job.job_name 



--Câu 1 Tìm số lượng worker của mỗi ngành nghề
SELECT j.job_id, j.job_name, COUNT(w.worker_id) AS num_workers
FROM abroad.job j
    LEFT JOIN abroad.worker_information w ON j.job_id = w.job_id
GROUP BY j.job_id, j.job_name;



--Câu 2 Tìm các job đang chưa tuyển đủ người trong recruitment time để có thể tìm thêm người
SELECT
    r.recruitment_id,
    COUNT(si.student_id) AS num_students,
    r.quantity,
    (r.quantity - COUNT(si.student_id)) AS Slot_left
FROM
    abroad.recruitment r
    LEFT JOIN
    student.information si ON r.recruitment_id = si.recruitment_id
GROUP BY 
    r.recruitment_id, r.quantity
HAVING 
    COUNT(si.student_id) < r.quantity;



-- câu 3 :tìm số lượng học viên sẽ bay vào tháng 11/2024
USE labour_export;
select * from student.information
where est_departure_date like '__-11-2024';



--câu 4 tìm tên các công ty của 1 nghiệp đoàn bất kì 

select *
from abroad.company as C
    join abroad.association A on C.asso_id = A.asso_id
where A.asso_name = 'Toyoyo Kigyo Kyodo Kumiai';




--câu 5 tìm thông tin người thân cuar những người lao đọngo gặp vấn đề
select 
    wp.worker_id,
    wi.worker_name,
    wd.dependence_name,
    wd.relationship,
    wd.dependence_phone
from abroad.worker_problem as wp
    join abroad.worker_information as wi on wp.worker_id = wi.worker_id
    join abroad.worker_dependence as wd on wi.worker_id = wd.worker_id
order by wp.worker_id




--Danh sách phòng ban, tên phòng ban và số lượng nhân viên mỗi phòng ban tại chi nhánh Hà Nội (sắp xếp giảm dần theo số lượng nhân viên)
SELECT 
   d.department_id,
   d.department_name,
   count(s.staff_id)
FROM
   domestic.staff as s 
   join domestic.department as d on s.department_id = d.department_id
WHERE s.office_id = 'HN'
GROUP BY d.department_id, d.department_name
ORDER BY count(s.staff_id) desc



--Danh sách lớp học, số lượng học viên, tên giáo viên giảng dạy và số điện thoại liên hệ giáo viên (sắp xếp tăng dần theo số lượng học viên)
SELECT 
   stu.class_id,
   sta.staff_name,
   sta.staff_phone, 
   count(stu.student_id)
FROM
   student.information as stu
   join domestic.staff as sta on stu.teacher_id = sta.staff_id
GROUP BY stu.class_id, sta.staff_name, sta.staff_phone
ORDER BY count(stu.student_id) asc

--Danh sách học sinh, tên người thân, quan hệ người thân và 
--số điện thoại liên hệ người thân học sinh
SELECT
   s.student_id,
   s.student_name,
   d.dependence_name,
   d.relationship,
   d.dependence_phone
FROM 
   student.information as s
   join student.dependence as d on s.student_id = d.student_id


--Số lượng người lao động hiện tại đang làm việc đối với 
--mỗi công việc và lương dự kiến tuyển dụng của công việc đó (sắp xếp giảm dần theo số lượng người lao động)
SELECT
   j.job_id,
   j.job_name,
   j.est_salary,
   count(w.worker_id)
FROM
   abroad.worker_information as w
   join abroad.job as j on w.job_id = j.job_id
GROUP BY j.job_id, j.job_name, j.est_salary
ORDER BY count(w.worker_id) desc

--Danh sách người lao động đang gặp vấn đề, mô tả vấn đề đang gặp phải
SELECT 
   w.worker_id,
   w.worker_name,
   p.problem_description
FROM
   abroad.worker_problem as p 
   join abroad.worker_information as w on p.worker_id = w.worker_id


--Danh sách người lao động đang gặp vấn đề, tên người thân, 
--quan hệ và số điện thoại người thân người lao động
SELECT
   w.worker_id,
   w.worker_name,
   d.dependence_name,
   d.relationship,
   d.dependence_phone
FROM
   abroad.worker_problem as p 
   join abroad.worker_information as w on p.worker_id = w.worker_id
   join abroad.worker_dependence as d on p.worker_id = d.worker_id

--Danh sách các công ty Nhật Bản, email công ty, 
--job tuyển dụng cùng mức lương dự kiến và số lượng lao động cần tuyển (sắp xếp tăng dần theo số lượng lao động, giảm dần theo mức lương)
SELECT
   c.company_id,
   c.company_name, 
   c.company_email,
   j.job_id,
   j.job_name,
   j.est_salary,
   r.quantity
FROM 
   abroad.recruitment as r 
   join abroad.company as c on r.company_id = c.company_id
   join abroad.job as j on c.company_id = r.company_id
ORDER BY r.quantity asc, j.est_salary desc 


--Danh sách công ty Nhật bản, các nghiệp đoàn liên kết, số điện thoại và địa chỉ các nghiệp đoàn
SELECT
   c.company_id,
   c.company_name, 
   a.asso_id,
   a.asso_name,
   a.asso_contact,
   a.asso_address
FROM
   abroad.company as c 
   join abroad.association as a on c.asso_id = a.asso_id

--Câu 8:
--Danh sách lớp học, số lượng học viên, tên giáo viên giảng dạy và số điện thoại liên hệ giáo viên (sắp xếp tăng dần theo số lượng học viên)
SELECT 
   cla.class_id,
   sta.staff_name,
   sta.staff_phone, 
   count(stu.student_id)
FROM
   student.information as stu
   join student.class as cla on stu.class_id = cla.class_id
   join domestic.staff as sta on cla.teacher_id = sta.staff_id
GROUP BY cla.class_id, sta.staff_name, sta.staff_phone
ORDER BY count(stu.student_id) asc

