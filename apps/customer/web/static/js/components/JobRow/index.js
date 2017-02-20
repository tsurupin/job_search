import React, { PropTypes } from 'react';
import { Link } from 'react-router';

const propTypes = {
  id: PropTypes.number.isRequired,
  jobTitle: PropTypes.string.isRequired,
  area: PropTypes.string.isRequired,
  updatedAt: PropTypes.string.isRequired,
  techs: PropTypes.array.isRequired
};

const JobRow = ({ id, jobTitle, area, updatedAt, techs }) =>{
  return (
    <div>
      <Link to={`/jobs/${id}`} >
        {jobTitle}
      </Link>
      <p>{area}</p>
      <p>{updatedAt}</p>
      <p>{techs.join(",")}</p>

    </div>
  )
};

JobRow.propTypes = propTypes;
export default JobRow;