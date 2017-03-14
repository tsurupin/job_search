import React, { PropTypes } from 'react';
import { FavoriteJobRow } from 'components';

const propTypes = {
  favoriteJobs: PropTypes.array.isRequired,
  handleRemove: PropTypes.func.isRequired,
  handleUpdate: PropTypes.func.isRequired
};

const FavoriteJobTable = ({favoriteJobs, handleRemove, handleUpdate}) =>{

  return (
    <table>
      {renderFavoriteJobRows(favoriteJobs, handleRemove, handleUpdate)}
    </table>
  )
};

function renderFavoriteJobRows(favoriteJobs, remove, update) {
  return favoriteJobs.map((favoriteJob, index) => {
    const property = {...favoriteJob, index, handleRemove: remove, handleUpdate: update};
    return <FavoriteJobRow key={favoriteJob.jobId} {...property} />
  })
}

FavoriteJobTable.propTypes = propTypes;
export default FavoriteJobTable;