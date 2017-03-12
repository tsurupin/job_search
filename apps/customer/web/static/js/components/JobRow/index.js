import React, { PropTypes } from 'react';
import { Link } from 'react-router';
import { FavoriteButton } from 'components';

const propTypes = {
  id: PropTypes.number.isRequired,
  jobTitle: PropTypes.string.isRequired,
  area: PropTypes.string.isRequired,
  updatedAt: PropTypes.string.isRequired,
  techs: PropTypes.array.isRequired,
  favorited: PropTypes.bool,
  handleSwitchFavoriteStatus: PropTypes.func.isRequired
};

const JobRow = ({id, jobTitle, area, updatedAt, techs, index, favorited, submitting, handleSwitchFavoriteStatus}) =>{
  return (
    <div>
      <Link to={`/jobs/${id}`} >
        {jobTitle}
      </Link>
      <p>{area}</p>
      <p>{updatedAt}</p>
      <p>{techs.join(",")}</p>
      {renderFavoriteButton(id, favorited, submitting, index, handleSwitchFavoriteStatus)}
    </div>
  )
};

function renderFavoriteButton(id, favorited, submitting = false, index, fnc) {
  if (favorited === undefined) { return }
  return (
    <FavoriteButton
      jobId={id}
      favorited={favorited}
      submitting={submitting}
      index={index}
      handleSwitchFavoriteStatus={fnc}
    />
  );
}

JobRow.propTypes = propTypes;
export default JobRow;